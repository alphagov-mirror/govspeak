require 'addressable/uri'

module Govspeak
  class HtmlSanitizer
    class ImageSourceWhitelister
      def initialize(allowed_image_hosts)
        @allowed_image_hosts = allowed_image_hosts
      end

      def call(sanitize_context)
        return unless sanitize_context[:node_name] == 'img'

        node = sanitize_context[:node]
        image_uri = Addressable::URI.parse(node['src'])
        return if image_uri.relative? || @allowed_image_hosts.include?(image_uri.host)

        node.unlink # the node isn't sanitary. Remove it from the document.
      end
    end

    class TableCellTextAlignWhitelister
      def call(sanitize_context)
        return unless %w[td th].include?(sanitize_context[:node_name])

        node = sanitize_context[:node]

        # Kramdown uses text-align to allow table cells to be aligned
        # http://kramdown.gettalong.org/quickref.html#tables
        node.remove_attribute('style') if invalid_style_attribute?(node['style'])
      end

      def invalid_style_attribute?(style)
        style && !style.match(/^text-align:\s*(center|left|right)$/)
      end
    end

    def initialize(dirty_html, options = {})
      @dirty_html = dirty_html
      @allowed_image_hosts = options[:allowed_image_hosts]
    end

    def sanitize
      transformers = [TableCellTextAlignWhitelister.new]
      transformers << ImageSourceWhitelister.new(@allowed_image_hosts) if @allowed_image_hosts&.any?
      Sanitize.clean(@dirty_html, Sanitize::Config.merge(sanitize_config, transformers: transformers))
    end

    def sanitize_config
      Sanitize::Config.merge(
        Sanitize::Config::RELAXED,
        elements: Sanitize::Config::RELAXED[:elements] + %w[govspeak-embed-attachment govspeak-embed-attachment-link],
        attributes: {
          :all => Sanitize::Config::RELAXED[:attributes][:all] + %w[role aria-label],
          'a' => Sanitize::Config::RELAXED[:attributes]['a'] + [:data],
          'th' => Sanitize::Config::RELAXED[:attributes]['th'] + %w[style],
          'td' => Sanitize::Config::RELAXED[:attributes]['td'] + %w[style],
          'govspeak-embed-attachment' => %w[content-id]
        }
      )
    end
  end
end

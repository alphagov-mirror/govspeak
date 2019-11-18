require 'test_helper'

class GovspeakAttachmentTest < Minitest::Test
  def render_govspeak(govspeak, attachments = [])
    Govspeak::Document.new(govspeak, attachments: attachments).to_html
  end

  test 'renders an empty string for attachment link that is not found' do
    assert_equal("\n", render_govspeak('[Attachment:file.pdf]', []))
  end

  test 'renders an attachment component for a found attachment' do
    attachment = {
      id: 'attachment.pdf',
      url: 'http://example.com/attachment.pdf',
      title: 'Attachment Title'
    }

    rendered = render_govspeak('[Attachment:attachment.pdf]', [attachment])
    assert_match(/<section class="gem-c-attachment">/, rendered)
    assert_match(/Attachment Title/, rendered)
  end

  test 'only renders attachment when markdown extension starts on a line' do
    attachment = {
      id: 'attachment.pdf',
      url: 'http://example.com/attachment.pdf',
      title: 'Attachment Title'
    }

    rendered = render_govspeak('some text [Attachment:attachment.pdf]', [attachment])
    assert_equal("<p>some text [Attachment:attachment.pdf]</p>\n", rendered)

    rendered = render_govspeak('[Attachment:attachment.pdf] some text', [attachment])
    assert_match(/<section class="gem-c-attachment">/, rendered)
    assert_match(%r{<p>some text</p>}, rendered)
  end
end

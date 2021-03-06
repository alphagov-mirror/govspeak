require "test_helper"

class GovspeakTableWithHeadersTest < Minitest::Test
  def expected_outcome
    %(
<table>
  <thead>
    <tr>
      <td></td>
      <th scope="col">Second Column</th>
      <th scope="col">Third Column</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">First row</th>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
    <tr>
      <th scope="row">Second row</th>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
  </tbody>
</table>
)
  end

  def expected_outcome_with_hashes_in_cell_contents
    %(
<table>
  <thead>
    <tr>
      <td></td>
      <th scope="col">Second Column</th>
      <th scope="col">Third Column</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">First row</th>
      <td># Cell</td>
      <td># Cell</td>
    </tr>
    <tr>
      <th scope="row">Second row</th>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
  </tbody>
</table>
)
  end

  def expected_outcome_for_table_with_alignments
    %(
<table>
  <thead>
    <tr>
      <td style="text-align: left"></td>
      <th style="text-align: center" scope="col">Second Column</th>
      <th style="text-align: right" scope="col">Third Column</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th style="text-align: left" scope="row">First row</th>
      <td style="text-align: center">Cell</td>
      <td style="text-align: right">Cell</td>
    </tr>
    <tr>
      <th style="text-align: left" scope="row">Second row</th>
      <td style="text-align: center">Cell</td>
      <td style="text-align: right">Cell</td>
    </tr>
  </tbody>
</table>
)
  end

  def expected_outcome_for_table_headers_in_the_wrong_place
    %(
<table>
  <thead>
    <tr>
      <td></td>
      <th scope="col">Second Column</th>
      <th scope="col">Third Column</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">First row</th>
      <td># Cell</td>
      <td>Cell</td>
    </tr>
    <tr>
      <th scope="row">Second row</th>
      <td>Cell</td>
      <td># Cell</td>
    </tr>
  </tbody>
</table>
)
  end

  def expected_outcome_for_table_with_blank_table_headers
    %(
<table>
  <thead>
    <tr>
      <td></td>
      <th scope="col">Second Column</th>
      <th scope="col">Third Column</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td></td>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
    <tr>
      <th scope="row">Second row</th>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
  </tbody>
</table>
)
  end

  def expected_outcome_for_table_headers_containing_links
    %(
<table>
  <thead>
    <tr>
      <td></td>
      <th scope="col">Second Column</th>
      <th scope="col">Third Column</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Link contained in header <a rel="external" href="http://google.com">link1</a>
</th>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
    <tr>
      <th scope="row">No link</th>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
    <tr>
      <th scope="row"><a rel="external" href="http://www.bbc.co.uk">Whole header is link</a>
</th>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
  </tbody>
</table>
)
  end

  def document_body_with_hashes_for_all_headers
    @document_body_with_hashes_for_all_headers ||= Govspeak::Document.new(%(
|                 |# Second Column  |# Third Column       |
| --------------- | --------------- | ------------------- |
|# First row      | Cell            | Cell                |
|# Second row     | Cell            | Cell                |
))
  end

  def document_body_with_hashes_for_row_headers
    @document_body_with_hashes_for_row_headers ||= Govspeak::Document.new(%(
|                 | Second Column   | Third Column        |
| --------------- | --------------- | ------------------- |
|# First row      | Cell            | Cell                |
|# Second row     | Cell            | Cell                |
))
  end

  def document_body_with_alignments
    @document_body_with_alignments ||= Govspeak::Document.new(%(
|                 | Second Column   | Third Column        |
| :-------------- | :-------------: | ------------------: |
|# First row      | Cell            | Cell                |
|# Second row     | Cell            | Cell                |
))
  end

  def document_body_with_table_headers_in_the_wrong_place
    @document_body_with_table_headers_in_the_wrong_place ||= Govspeak::Document.new(%(
|                 | Second Column   | Third Column        |
| --------------- | --------------- | ------------------- |
|# First row      |# Cell           | Cell                |
|# Second row     | Cell            |# Cell               |
))
  end

  def document_body_with_blank_table_headers
    @document_body_with_blank_table_headers ||= Govspeak::Document.new(%(
|                 | Second Column   | Third Column        |
| --------------- | --------------- | ------------------- |
|#                | Cell            | Cell                |
|# Second row     | Cell            | Cell                |
))
  end

  def document_body_with_table_headers_containing_links
    @document_body_with_table_headers_containing_links ||= Govspeak::Document.new(%(
|                                                      | Second Column   | Third Column        |
| ---------------------------------------------------- | --------------- | ------------------- |
|# Link contained in header [link1](http://google.com) | Cell            | Cell                |
|# No link                                             | Cell            | Cell                |
|# [Whole header is link](http://www.bbc.co.uk)        | Cell            | Cell                |
))
  end

  test "Cells with |# are headers" do
    assert_equal document_body_with_hashes_for_all_headers.to_html, expected_outcome
  end

  test "Cells outside of thead with |# are th; thead still only contains th" do
    assert_equal document_body_with_hashes_for_row_headers.to_html, expected_outcome
  end

  test "Cells are aligned correctly" do
    assert_equal document_body_with_alignments.to_html, expected_outcome_for_table_with_alignments
  end

  test "Table headers with a scope of row are only in the first column of the table" do
    assert_equal document_body_with_table_headers_in_the_wrong_place.to_html, expected_outcome_for_table_headers_in_the_wrong_place
  end

  test "Table headers with a scope of row can have embedded links" do
    assert_equal document_body_with_table_headers_containing_links.to_html, expected_outcome_for_table_headers_containing_links
  end

  test "Table headers are not blank" do
    assert_equal document_body_with_blank_table_headers.to_html, expected_outcome_for_table_with_blank_table_headers
  end
end

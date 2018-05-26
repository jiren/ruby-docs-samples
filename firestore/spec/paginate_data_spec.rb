require_relative "../get_data.rb"
require_relative "../paginate_data.rb"
require "rspec"
require "google/cloud/firestore"

def delete_collection collection_name:
  firestore = Google::Cloud::Firestore.new(project_id: ENV["GOOGLE_CLOUD_PROJECT"])
  cities_ref = firestore.col collection_name
  query = cities_ref
  query.get do |document_snapshot|
    document_ref = document_snapshot.ref
    document_ref.delete
  end
end

describe "Google Cloud Firestore API samples - Paginate Data" do

  before do
    @firestore_project = ENV["GOOGLE_CLOUD_PROJECT"]
  end

  after do
    delete_collection collection_name: "cities"
  end

  # Capture and return STDOUT output by block
  def capture &block
    real_stdout = $stdout
    $stdout = StringIO.new
    block.call
    $stdout.string
  ensure
    $stdout = real_stdout
  end

  example "start_at_field_query_cursor" do
    retrieve_create_examples project_id: @firestore_project
    output = capture {
      start_at_field_query_cursor project_id: @firestore_project
    }
    expect(output).to include "Document LA returned by start at population 1000000 field query cursor."
    expect(output).to include "Document TOK returned by start at population 1000000 field query cursor."
    expect(output).to include "Document BJ returned by start at population 1000000 field query cursor."
    expect(output).not_to include "Document SF returned by start at population 1000000 field query cursor."
    expect(output).not_to include "Document DC returned by start at population 1000000 field query cursor."
  end

  example "end_at_field_query_cursor" do
    retrieve_create_examples project_id: @firestore_project
    output = capture {
      end_at_field_query_cursor project_id: @firestore_project
    }
    expect(output).to include "Document DC returned by end at population 1000000 field query cursor."
    expect(output).to include "Document SF returned by end at population 1000000 field query cursor."
    expect(output).not_to include "Document LA returned by end at population 1000000 field query cursor."
    expect(output).not_to include "Document TOK returned by end at population 1000000 field query cursor."
    expect(output).not_to include "Document BJ returned by end at population 1000000 field query cursor."
  end

  example "paginated_query_cursor" do
    retrieve_create_examples project_id: @firestore_project
    output = capture {
      paginated_query_cursor project_id: @firestore_project
    }
    expect(output).not_to include "Document DC returned by paginated query cursor."
    expect(output).not_to include "Document SF returned by paginated query cursor."
    expect(output).not_to include "Document LA returned by paginated query cursor."
    expect(output).to include "Document TOK returned by paginated query cursor."
    expect(output).to include "Document BJ returned by paginated query cursor."
  end

  example "multiple_cursor_conditions" do
    retrieve_create_examples project_id: @firestore_project
    output = capture {
      multiple_cursor_conditions project_id: @firestore_project
    }
    expect(output).not_to include "Document BJ returned by start at Springfield query."
    expect(output).not_to include "Document LA returned by start at Springfield query."
    expect(output).not_to include "Document SF returned by start at Springfield query."
    expect(output).to include "Document TOK returned by start at Springfield query."
    expect(output).to include "Document DC returned by start at Springfield query."
  end

end

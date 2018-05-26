require_relative "../add_data.rb"
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

describe "Google Cloud Firestore API samples - Add Data" do

  before do
    @firestore_project = ENV["GOOGLE_CLOUD_PROJECT"]
  end

  after do
    delete_collection collection_name: "cities"
    delete_collection collection_name: "data"
    delete_collection collection_name: "users"
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

  example "set_document" do
    output = capture {
      set_document project_id: @firestore_project
    }
    expect(output).to include "Set data for the LA document in the cities collection."
  end

  example "update_create_if_missing" do
    output = capture {
      update_create_if_missing project_id: @firestore_project
    }
    expect(output).to include "Merged data into the LA document in the cities collection."
  end

  example "set_document_data_types" do
    output = capture {
      set_document_data_types project_id: @firestore_project
    }
    expect(output).to include "Set multiple data-type data for the one document in the data collection."
  end

  example "set_requires_id" do
    output = capture {
      set_requires_id project_id: @firestore_project
    }
    expect(output).to include "Added document with ID: new-city-id."
  end

  example "add_doc_data_with_auto_id" do
    output = capture {
      add_doc_data_with_auto_id project_id: @firestore_project
    }
    expect(output).to include "Added document with ID:"
  end

  example "add_doc_data_after_auto_id" do
    output = capture {
      add_doc_data_after_auto_id project_id: @firestore_project
    }
    expect(output).to include "Added document with ID:"
    expect(output).to include "Added data to the"
    expect(output).to include "document in the cities collection."
  end

  example "update_doc" do
    output = capture {
      update_doc project_id: @firestore_project
    }
    expect(output).to include "Updated the capital field of the DC document in the cities collection."
  end

  example "update_nested_fields" do
    output = capture {
      update_nested_fields project_id: @firestore_project
    }
    expect(output).to include "Updated the age and favorite color fields of the frank document in the users collection."
  end

  example "update_server_timestamp" do
    output = capture {
      set_requires_id project_id: @firestore_project
      update_server_timestamp project_id: @firestore_project
    }
    expect(output).to include "Updated the timestamp field of the new-city-id document in the cities collection."
  end
end

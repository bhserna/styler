require "spec_helper"

RSpec.describe Styler, "#nested_collections" do
  it "with just the default collection" do
    subject = described_class.new do
      style :btn, ["pa3", "blue"]
    end

    expect(subject.nested_collections).to match_array []
  end

  it "with one collection" do
    subject = described_class.new do
      collection :buttons do
        style :btn, ["pa3", "blue"]
      end
    end

    expect(subject.nested_collections).to match_array [subject.buttons]
  end

  it "with two collections" do
    subject = described_class.new do
      collection :headers do
        style :h1, ["pa3"]
      end

      collection :buttons do
        style :btn, ["pa3", "blue"]
      end
    end

    expect(subject.nested_collections).to match_array [subject.buttons, subject.headers]
  end

  it "with one nested collection" do
    subject = described_class.new do
      collection :headers do
        style :h1, ["pa3"]

        collection :buttons do
          style :btn, ["pa3", "blue"]
        end
      end
    end

    expect(subject.nested_collections).to match_array [subject.headers, subject.headers.buttons]
  end

  it "with two nested collection" do
    subject = described_class.new do
      collection :headers do
        collection :titles do
          style :h1, ["pa3"]
        end

        collection :buttons do
          style :btn, ["pa3", "blue"]
        end
      end
    end

    expect(subject.nested_collections).to match_array [
      subject.headers,
      subject.headers.titles,
      subject.headers.buttons
    ]
  end

  it "with two nesting levels collection" do
    subject = described_class.new do
      collection :headers do
        collection :titles do
          style :h1, ["pa3"]

          collection :buttons do
            style :btn, ["pa3", "blue"]
          end
        end
      end
    end

    expect(subject.nested_collections).to match_array [
      subject.headers,
      subject.headers.titles,
      subject.headers.titles.buttons
    ]
  end
end

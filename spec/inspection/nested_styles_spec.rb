require "spec_helper"

RSpec.describe Styler, "#nested_styles" do
  it "with just the default collection" do
    subject = described_class.new do
      style :btn, ["pa3", "blue"]
    end

    expect(subject.nested_styles).to match_array [subject.btn]
  end

  it "with one collection" do
    subject = described_class.new do
      style :btn, ["pa3", "blue"]

      collection :buttons do
        style :btn, ["pa3", "red"]
      end
    end

    expect(subject.nested_styles).to match_array [
      subject.btn,
      subject.buttons.btn
    ]
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

    expect(subject.nested_styles).to match_array [
      subject.headers.h1,
      subject.buttons.btn
    ]
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

    expect(subject.nested_styles).to match_array [
      subject.headers.h1,
      subject.headers.buttons.btn
    ]
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

    expect(subject.nested_styles).to match_array [
      subject.headers.titles.h1,
      subject.headers.buttons.btn
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

    expect(subject.nested_styles).to match_array [
      subject.headers.titles.h1,
      subject.headers.titles.buttons.btn
    ]
  end
end

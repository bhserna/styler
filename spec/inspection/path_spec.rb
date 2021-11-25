require "spec_helper"

RSpec.describe Styler, "#path" do
  it "with the root collection" do
    subject = described_class.new do
    end

    expect(subject.path).to eq "root"
  end

  it "with a collection" do
    subject = described_class.new do
      collection :buttons do
      end
    end

    expect(subject.buttons.path).to eq "root.buttons"
  end

  it "with two collections" do
    subject = described_class.new do
      collection :headers do
      end

      collection :buttons do
      end
    end

    expect(subject.headers.path).to eq "root.headers"
    expect(subject.buttons.path).to eq "root.buttons"
  end

  it "with nested collection" do
    subject = described_class.new do
      collection :headers do
        collection :buttons do
        end
      end
    end

    expect(subject.headers.buttons.path).to eq "root.headers.buttons"
  end

  it "with other nested collection" do
    subject = described_class.new do
      collection :headers do
        collection :titles do
          collection :buttons do
          end
        end
      end
    end

    expect(subject.headers.titles.buttons.path).to eq "root.headers.titles.buttons"
  end
end

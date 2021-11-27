require "spec_helper"

RSpec.describe Styler, "collection" do
  it "with default styles" do
    subject = described_class.new do
      collection :buttons do
        style :default, ["pa3", "blue"]
        style :danger, ["pa3", "red"]
      end
    end

    expect(subject).not_to respond_to :default
    expect(subject).not_to respond_to :danger
    expect(subject.buttons.default).to eq subject.buttons.default
    expect(subject.buttons.danger).to eq subject.buttons.danger
    expect(subject.buttons.default.to_s).to eq "pa3 blue"
    expect(subject.buttons.danger.to_s).to eq "pa3 red"
  end

  it "with custom styles" do
    subject = described_class.new do
      collection :buttons do
        style :default, ["pa3", "blue"]
        style :danger, [default, "red"]
      end
    end

    expect(subject).not_to respond_to :default
    expect(subject).not_to respond_to :danger
    expect(subject.buttons.default.to_s).to eq "pa3 blue"
    expect(subject.buttons.danger.to_s).to eq "pa3 blue red"
  end

  it "with nested collection" do
    subject = described_class.new do
      collection :v1 do
        collection :buttons do
          style :default, ["pa3", "blue"]
          style :danger, [default - "blue", "red"]
        end
      end
    end

    expect(subject.v1.buttons.default.to_s).to eq "pa3 blue"
    expect(subject.v1.buttons.danger.to_s).to eq "pa3 red"
  end

  it "with two nested collection" do
    subject = described_class.new do
      collection :v1 do
        collection :buttons do
          style :default, ["pa3", "blue"]
        end
      end

      collection :v2 do
        collection :buttons do
          style :default, ["pa3", "red"]
        end
      end
    end

    expect(subject.v1.buttons.default.to_s).to eq "pa3 blue"
    expect(subject.v2.buttons.default.to_s).to eq "pa3 red"
  end

  it "with style with the same name than the default colection" do
    subject = described_class.new do
      style :danger, ["red"]

      collection :buttons do
        style :default, ["pa3", "blue"]
        style :danger, ["pa3", "red"]
      end
    end

    expect(subject.danger.to_s).to eq "red"
    expect(subject.buttons.default.to_s).to eq "pa3 blue"
    expect(subject.buttons.danger.to_s).to eq "pa3 red"
  end

  it "substracting" do
    subject = described_class.new do
      collection :buttons do
        style :default, ["pa3", "blue"]
        style :danger, [default - "blue", "red"]
      end
    end

    expect(subject.buttons.default.to_s).to eq "pa3 blue"
    expect(subject.buttons.danger.to_s).to eq "pa3 red"
  end

  it "passing arguments" do
    subject = described_class.new do
      collection :buttons do |project|
        if project[:color] == "blue"
          style :default, ["pa3", "blue"]
        else
          style :default, ["pa3", "red"]
        end
      end
    end

    project = { color: "blue" }
    expect(subject.buttons(project).default.to_s).to eq "pa3 blue"

    project = { color: "red" }
    expect(subject.buttons(project).default.to_s).to eq "pa3 red"
  end
end

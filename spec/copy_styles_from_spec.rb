require "spec_helper"

RSpec.describe Styler, "copy_styles_from" do
  it "with default styles" do
    subject = described_class.new do
      collection :buttons do
        style :default, ["pa3", "blue"]
        style :danger, ["pa3", "red"]
      end

      collection :new_buttons do
        copy_styles_from collection: buttons
      end
    end

    expect(subject.new_buttons.default).to eq subject.buttons.default
    expect(subject.new_buttons.danger).to eq subject.buttons.danger
    expect(subject.new_buttons.default.to_s).to eq "pa3 blue"
    expect(subject.new_buttons.danger.to_s).to eq "pa3 red"
  end

  it "with custom styles" do
    subject = described_class.new do
      collection :buttons do
        style :default, ["pa3", "blue"]
        style :danger, [default, "red"]
      end

      collection :new_buttons do
        copy_styles_from collection: buttons
      end
    end

    expect(subject.new_buttons.default.to_s).to eq "pa3 blue"
    expect(subject.new_buttons.danger.to_s).to eq "pa3 blue red"
  end

  it "with nested collection" do
    subject = described_class.new do
      collection :v1 do
        collection :buttons do
          style :default, ["pa3", "blue"]
          style :danger, [default - "blue", "red"]
        end
      end

      collection :v2 do
        collection :buttons do
          copy_styles_from collection: v1.buttons
        end
      end
    end

    expect(subject.v2.buttons.default.to_s).to eq "pa3 blue"
    expect(subject.v2.buttons.danger.to_s).to eq "pa3 red"
  end

  it "overriding styles" do
    subject = described_class.new do
      collection :v1 do
        collection :buttons do
          style :default, ["pa3", "blue"]
          style :danger, [default - "blue", "red"]
        end
      end

      collection :v2 do
        collection :buttons do
          copy_styles_from collection: v1.buttons
          style :danger, [v1.buttons.danger - "red", "orange"]
        end
      end
    end

    expect(subject.v2.buttons.default.to_s).to eq "pa3 blue"
    expect(subject.v2.buttons.danger.to_s).to eq "pa3 orange"
  end
end

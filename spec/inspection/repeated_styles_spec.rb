require "spec_helper"

RSpec.describe Styler, "#repeted_styles" do
  it "with just one class" do
    subject = described_class.new do
      style :btn1, ["blue"]
      style :btn2, ["blue"]
      style :btn3, ["red"]
    end

    expect(subject.repeted_styles).to match_array [[subject.btn1, subject.btn2]]
  end

  it "with two classes" do
    subject = described_class.new do
      style :btn1, [:pa3, "blue"]
      style :btn2, [:pa3, "blue"]
      style :btn3, ["red"]
    end

    expect(subject.repeted_styles).to match_array [[subject.btn1, subject.btn2]]
  end

  it "from child collection" do
    subject = described_class.new do
      style :btn1, [:pa3, "blue"]

      collection :child do
        style :btn2, [:pa3, "blue"]
        style :btn3, ["red"]
      end
    end

    expect(subject.repeted_styles).to match_array [[subject.btn1, subject.child.btn2]]
  end

  it "from collection nested two levels" do
    subject = described_class.new do
      style :btn1, [:pa3, "blue"]

      collection :child do
        style :btn1, [:pa3, "blue"]
        style :btn2, ["red"]

        collection :child2 do
          style :btn1, [:pa3, "blue"]
          style :btn2, ["red"]
        end
      end
    end

    expect(subject.repeted_styles).to match_array [
      [subject.btn1, subject.child.btn1, subject.child.child2.btn1],
      [subject.child.btn2, subject.child.child2.btn2]
    ]
  end
end

require "spec_helper"

RSpec.describe Styler, "collection_alias" do
  it "selects a collection" do
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

      collection_alias :theme, v1
    end

    expect(subject.theme.buttons.default.to_s).to eq "pa3 blue"
  end

  it "with a block" do
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

      collection_alias :theme do
        v1
      end
    end

    expect(subject.theme.buttons.default.to_s).to eq "pa3 blue"
  end

  it "with a block with arguments" do
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

      collection_alias :theme do |current_version|
        if current_version == "v1"
          v1
        else
          v2
        end
      end
    end

    expect(subject.theme("v1").buttons.default.to_s).to eq "pa3 blue"
    expect(subject.theme("v2").buttons.default.to_s).to eq "pa3 red"
  end

  it "from other styler" do
    v1 = described_class.new do
      collection :buttons do
        style :default, ["pa3", "blue"]
      end
    end

    v2 = described_class.new do
      collection :buttons do
        style :default, ["pa3", "red"]
      end
    end

    subject = described_class.new do
      collection_alias :theme, v1
    end

    expect(subject.theme.buttons.default.to_s).to eq "pa3 blue"
  end

  it "from other styler with block and arguments" do
    v1 = described_class.new do
      collection :buttons do
        style :default, ["pa3", "blue"]
      end
    end

    v2 = described_class.new do
      collection :buttons do
        style :default, ["pa3", "red"]
      end
    end

    subject = described_class.new do
      collection_alias :theme do |current_version|
        if current_version == "v1"
          v1
        else
          v2
        end
      end
    end

    expect(subject.theme("v1").buttons.default.to_s).to eq "pa3 blue"
    expect(subject.theme("v2").buttons.default.to_s).to eq "pa3 red"
  end
end

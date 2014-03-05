require 'spec_helper'

describe AvetmissData::Base do
  let!(:base) { build :base }

  context '#file_format_hash' do
    before { AvetmissData::Base.file_format = {} }
    specify { expect(base.file_format_hash).not_to be_nil }
  end

  context 'reading/writing' do
    before do
      AvetmissData::Base.file_format = {
        foo: 0...5,
        bar: 5...10,
        baz: 10..-1
      }
    end

    context '.parse' do
      specify do
        expect(AvetmissData::Base.parse("12345abcdeLOL")).to eq({
          foo: "12345",
          bar: "abcde",
          baz: "LOL"
        })
      end

      specify do
        expect(AvetmissData::Base.parse("1 3  ab   LOL")).to eq({
          foo: "1 3",
          bar: "ab",
          baz: "LOL"
        })
      end

      specify do
        expect(AvetmissData::Base.parse(" 23 5   deLOL")).to eq({
          foo: "23 5",
          bar: "de",
          baz: "LOL"
        })
      end

      specify do
        expect(AvetmissData::Base.parse("12345abcde")).to eq({
          foo: "12345",
          bar: "abcde",
          baz: ""
        })
      end
    end

    context ".max_record" do
      specify { expect(AvetmissData::Base.max_record).to eq(10) }
    end

    context ".to_record" do
      specify do
        expect(AvetmissData::Base.to_record({
          foo: "12345",
          bar: "abcde",
          baz: "LOL"
        })).to eq("12345abcdeLOL")
      end

      specify do
        expect(AvetmissData::Base.to_record({
          foo: "12 3 ",
          bar: "a  de",
          baz: "L L"
        })).to eq("12 3 a  deL L")
      end

      specify do
        expect(AvetmissData::Base.to_record({
          foo: "  345",
          bar: "  c e",
          baz: " OL"
        })).to eq("  345  c e OL")
      end

      specify do
        expect(AvetmissData::Base.to_record({
          foo: "12345",
          bar: "abcde",
          baz: "LOL",
          cool: "bananas"
        })).to eq("12345abcdeLOL")
      end

      specify do
        expect(AvetmissData::Base.to_record({
          foo: "12345",
          baz: "LOL"
        })).to eq("12345     LOL")
      end
    end
  end
        


end

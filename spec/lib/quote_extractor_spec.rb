require 'spec_helper'

describe QuoteExtractor do
  describe 'extracts' do
    describe 'simple' do
      describe 'one' do
        it "[quote][/quote]" do
          QuoteExtractor.extract("[quote][/quote]").should == [{
            tags: [],
            start: 0,
            end: 15
          }]
        end

        it "[quote=morr][/quote]" do
          QuoteExtractor.extract("[quote=morr][/quote]").should == [{
            tags: [],
            start: 0,
            end: 20
          }]
        end

        it "[quote][/quote]a" do
          QuoteExtractor.extract("[quote][/quote]a").should == [{
            tags: [],
            start: 0,
            end: 15
          }]
        end

        it "[quote]d[/quote]" do
          QuoteExtractor.extract("[quote]d[/quote]").should == [{
            tags: [],
            start: 0,
            end: 16
          }]
        end

        it "[quote]d[/quote]e" do
          QuoteExtractor.extract("[quote]d[/quote]e").should == [{
            tags: [],
            start: 0,
            end: 16
          }]
        end
      end

      describe 'multiple' do
        it "[quote][/quote][quote][/quote]" do
          QuoteExtractor.extract("[quote][/quote][quote][/quote]").should == [{
            tags: [],
            start: 0,
            end: 15
          }, {
            tags: [],
            start: 15,
            end: 30
          }]
        end

        it "aa[quote]zxc[/quote]bb[quote][/quote]zz" do
          QuoteExtractor.extract("aa[quote]zxc[/quote]bb[quote][/quote]zz").should == [{
            tags: [],
            start: 2,
            end: 20
          }, {
            tags: [],
            start: 22,
            end: 37
          }]
        end

        it "[quote][/quote][quote][/quote][quote][/quote]" do
          QuoteExtractor.extract("[quote][/quote][quote][/quote][quote][/quote]").should == [{
            tags: [],
            start: 0,
            end: 15
          }, {
            tags: [],
            start: 15,
            end: 30
          }, {
            tags: [],
            start: 30,
            end: 45
          }]
        end
      end
    end

    describe 'nested' do
      it "[quote][quote][/quote][/quote]" do
        QuoteExtractor.extract("[quote][quote][/quote][/quote]").should == [{
            tags: [{
              tags: [],
              start: 7,
              end: 22
            }],
            start: 0,
            end: 30
        }]
      end

      it "z[quote]1[quote]zxcv[/quote][/quote]f" do
        QuoteExtractor.extract("z[quote]1[quote]zxcv[/quote][/quote]f").should == [{
            tags: [{
              tags: [],
              start: 9,
              end: 28
            }],
            start: 1,
            end: 36
        }]
      end

      it "[quote][quote][/quote][quote][/quote][/quote]" do
        QuoteExtractor.extract("[quote][quote][/quote][quote][/quote][/quote]").should == [{
            tags: [{
              tags: [],
              start: 7,
              end: 22
            }, {
              tags: [],
              start: 22,
              end: 37
            }],
            start: 0,
            end: 45
        }]
      end

      it "[quote][quote][/quote][quote][quote]yahoo![/quote][/quote][/quote]" do
        QuoteExtractor.extract("[quote][quote][/quote][quote][quote]yahoo![/quote][/quote][/quote]").should == [{
            tags: [{
              tags: [],
              start: 7,
              end: 22
            }, {
              tags: [{
                tags: [],
                start: 29,
                end: 50
              }],
              start: 22,
              end: 58
            }],
            start: 0,
            end: 66
        }]
      end
    end

    describe 'broken' do
      it "[quote]" do
        QuoteExtractor.extract("[quote]").should == []
      end

      it "[/quote]" do
        QuoteExtractor.extract("[/quote]").should == []
      end

      it "[/quote][quote]" do
        QuoteExtractor.extract("[/quote][quote]").should == []
      end

      it "[quote][quote]" do
        QuoteExtractor.extract("[quote][quote]").should == []
      end

      it "[quote][quote][/quote]" do
        QuoteExtractor.extract("[quote][quote][/quote]").should == [{
          tags: [],
          start: 7,
          end: 22,
        }]
      end

      it "[quote]b[/quote]c[/quote]" do
        QuoteExtractor.extract('[quote]b[/quote]c[/quote]').should == [{
          tags: [],
          start: 0,
          end: 16
        }]
      end
    end
  end

  describe 'filters' do
    describe '0 lvl' do
      it 'simple' do
        QuoteExtractor.filter('a[quote]b[/quote]c', 0).should == 'ac'
        QuoteExtractor.filter('a[quote][quote]b[/quote][/quote]c', 0).should == 'ac'
        QuoteExtractor.filter('[quote]b[/quote]c', 0).should == 'c'
        QuoteExtractor.filter('[quote][/quote]c', 0).should == 'c'
        QuoteExtractor.filter('[quote][/quote]', 0).should == ''
        QuoteExtractor.filter('[quote=morr][/quote]', 0).should == ''
      end

      it 'multiple' do
        QuoteExtractor.filter('a[quote]b[/quote]c[quote]d[/quote]e', 0).should == 'ace'
      end

      it 'mismatched tags' do
        QuoteExtractor.filter('a[quote=zz]b[/quote]c[/quote]d', 0).should == 'ac[/quote]d'
      end
    end

    describe '1 lvl' do
      it 'simple' do
        QuoteExtractor.filter('a[quote]b[quote]c[/quote]d[/quote]e', 1).should == 'a[quote]bd[/quote]e'
        QuoteExtractor.filter('a[quote]b[quote]c[quote]d[/quote]e[/quote]f[/quote]g', 1).should == 'a[quote]bf[/quote]g'
      end

      it 'multiple' do
        QuoteExtractor.filter('a[quote]b[quote]c[/quote]d[quote]e[/quote]f[/quote]g', 1).should == 'a[quote]bdf[/quote]g'
      end
    end

    describe '2 lvl' do
      it 'simple' do
        QuoteExtractor.filter('a[quote]b[quote]c[quote]d[/quote]e[/quote]f[/quote]g', 2).should == 'a[quote]b[quote]ce[/quote]f[/quote]g'
      end
    end
  end
end

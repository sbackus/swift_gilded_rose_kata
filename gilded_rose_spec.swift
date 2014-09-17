
import GildedRose
import XCTest

describe "#updateQuality" do

  context "with a single" do
    Given(:initial_sellIn) { 5 }
    Given(:initial_quality) { 10 }
    Given(:item) { Item.new(name, initial_sellIn, initial_quality) }

    When { updateQuality([item]) }

    context "normal item" do
      Given(:name) { "NORMAL ITEM" }

      Invariant { item.sellIn.should == initial_sellIn-1 }

      context "before sell date" do
        Then { item.quality.should == initial_quality-1 }
      end

      context "on sell date" do
        Given(:initial_sellIn) { 0 }
        Then { item.quality.should == initial_quality-2 }
      end

      context "after sell date" do
        Given(:initial_sellIn) { -10 }
        Then { item.quality.should == initial_quality-2 }
      end

      context "of zero quality" do
        Given(:initial_quality) { 0 }
        Then { item.quality.should == 0 }
      end
    end

    context "Aged Brie" do
      Given(:name) { "Aged Brie" }

      Invariant { item.sellIn.should == initial_sellIn-1 }

      context "before sell date" do
        Then { item.quality.should == initial_quality+1 }

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sellIn) { 0 }
        Then { item.quality.should == initial_quality+2 }

        context "near max quality" do
          Given(:initial_quality) { 49 }
          Then { item.quality.should == 50 }
        end

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "after sell date" do
        Given(:initial_sellIn) { -10 }
        Then { item.quality.should == initial_quality+2 }

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end
    end

    context "Sulfuras" do
      Given(:initial_quality) { 80 }
      Given(:name) { "Sulfuras, Hand of Ragnaros" }

      Invariant { item.sellIn.should == initial_sellIn }

      context "before sell date" do
        Then { item.quality.should == initial_quality }
      end

      context "on sell date" do
        Given(:initial_sellIn) { 0 }
        Then { item.quality.should == initial_quality }
      end

      context "after sell date" do
        Given(:initial_sellIn) { -10 }
        Then { item.quality.should == initial_quality }
      end
    end

    context "Backstage pass" do
      Given(:name) { "Backstage passes to a TAFKAL80ETC concert" }

      Invariant { item.sellIn.should == initial_sellIn-1 }

      context "long before sell date" do
        Given(:initial_sellIn) { 11 }
        Then { item.quality.should == initial_quality+1 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
        end
      end

      context "medium close to sell date (upper bound)" do
        Given(:initial_sellIn) { 10 }
        Then { item.quality.should == initial_quality+2 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "medium close to sell date (lower bound)" do
        Given(:initial_sellIn) { 6 }
        Then { item.quality.should == initial_quality+2 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "very close to sell date (upper bound)" do
        Given(:initial_sellIn) { 5 }
        Then { item.quality.should == initial_quality+3 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "very close to sell date (lower bound)" do
        Given(:initial_sellIn) { 1 }
        Then { item.quality.should == initial_quality+3 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sellIn) { 0 }
        Then { item.quality.should == 0 }
      end

      context "after sell date" do
        Given(:initial_sellIn) { -10 }
        Then { item.quality.should == 0 }
      end
    end

    context "conjured item" do
      before { pending }
      Given(:name) { "Conjured Mana Cake" }

      Invariant { item.sellIn.should == initial_sellIn-1 }

      context "before the sell date" do
        Given(:initial_sellIn) { 5 }
        Then { item.quality.should == initial_quality-2 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sellIn) { 0 }
        Then { item.quality.should == initial_quality-4 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "after sell date" do
        Given(:initial_sellIn) { -10 }
        Then { item.quality.should == initial_quality-4 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { item.quality.should == initial_quality }
        end
      end
    end
  end

  context "with several objects" do
    Given(:items) {
      [
        Item.new("NORMAL ITEM", 5, 10),
        Item.new("Aged Brie", 3, 10),
      ]
    }

    When { updateQuality(items) }

    Then { items[0].quality.should == 9 }
    Then { items[0].sellIn.should == 4 }

    Then { items[1].quality.should == 11 }
    Then { items[1].sellIn.should == 2 }
  end
end

require 'spec_helper'

describe 'shop/index.html.haml', :type => "view" do
  before(:each) do
    @product1 = FactoryGirl.create(:product)
    @product2 = FactoryGirl.create(:product)
    assign(:products, [@product1, @product2])
    assign(:order_item, OrderItem.new)
  end

  context "signed in" do
    before(:each) do
      @member = FactoryGirl.create(:member)
      controller.stub(:current_user) { @member }
      render
    end

    it 'shows products' do
      assert_select("h2", :text => @product1.name)
    end

    it 'shows prices in AUD' do
      rendered.should contain '9.99 AUD'
    end

    it 'displays the order form' do
      assert_select "form", :count => 2
    end

    it 'renders markdown in product descriptions' do
      assert_select "em", :text => 'hurrah', :count => 2
    end
  end

  context "is paid" do
    before(:each) do
      @member = FactoryGirl.create(:member)
      @member.account.account_type = FactoryGirl.create(:paid_account_type)
      @member.account.paid_until = Time.zone.now + 1.year
      @member.save
      controller.stub(:current_user) { @member }
    end

    it "recognises the paid member" do
      @member.is_paid?.should be_true
    end

    it "tells you you have a paid membership" do
      pending "can't set up a paid member for some reason"
      render
      rendered.should contain "You currently have a paid"
    end

    it "doesn't show shop" do
      pending "can't set up a paid member for some reason"
      render
      assert_select "form", false
    end

  end

  context "signed out" do
    before(:each) do
      controller.stub(:current_user) { nil }
      render
    end

    it "tells you to sign up/sign in" do
      rendered.should contain "sign in or sign up"
    end
  end

end
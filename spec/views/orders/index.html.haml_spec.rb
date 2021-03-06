require 'rails_helper'

describe "orders/index" do
  before(:each) do
    @member = FactoryBot.create(:member)
    sign_in @member
    @order1 = FactoryBot.create(:order, member: @member)
    @order2 = FactoryBot.create(:completed_order, member: @member)
    assign(:orders, [@order1, @order2])
  end

  it "shows your current account status" do
    render
    rendered.should have_content "Your current account status"
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td a/@href", text: "/orders/#{@order1.id}"
    assert_select "tr>td a/@href", text: "/orders/#{@order2.id}"
  end
end

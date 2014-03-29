require 'spec_helper'

describe User do
  let(:user) { User.create(name: 'test') }

  it "should has no tags" do
    user.read_attribute(:tags).should eq([])
  end

  describe "tags" do
    describe "create" do
      it "should be able to create one tag" do
        tag = user.tags.new(name: 'bug', color: 'red')

        tag.save.should be_true
        tag.id.should_not be_nil

        user.reload.tags.any? {|t| t.name == 'bug'}.should be_true
      end

      it "should be unable to create tags with duplicate name" do
        user.tags.new(name: 'bug', color: 'red').save.should be_true

        tag = user.tags.new(name: 'bug', color: 'green')

        tag.save.should be_false
        tag.errors[:name].should_not be_empty
      end

      it "should be unable to create tags without color" do
        tag = user.tags.new(name: 'bug')

        tag.save.should be_false
        tag.errors[:color].should_not be_empty
      end
    end

    it "should be able to update record" do
      tag = user.tags.create(name: 'bug', color: 'red')

      user.reload.tags.any? {|t| t.name == 'bug'}.should be_true

      tag.update(color: 'yellow').should be_true

      user.reload.tags.any? {|t| t.color == 'yellow'}.should be_true
    end

    it "should be able to destroy" do
      tag = user.tags.create(name: 'bug', color: 'red')

      tag.destroy.should be_true

      user.reload.tags.any? {|t| t.name == 'bug'}.should be_false
    end
  end
end

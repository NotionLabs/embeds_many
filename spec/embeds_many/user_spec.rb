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

      it "should to initialize an tag with no parameters" do
        user.tags.new.should_not be_nil
      end

      it "should be unable to create tags with duplicate name" do
        user.tags.new(name: 'bug', color: 'red').save.should be_true

        tag = user.tags.new(name: 'bug', color: 'green')

        tag.save.should be_false
        tag.errors[:name].should_not be_empty
      end

      it "should be unable to create tags without name" do
        tag = user.tags.new(color: 'red')

        tag.save.should be_false
        tag.errors[:name].should_not be_empty
      end

      it "should be unable to create tags without color" do
        tag = user.tags.new(name: 'bug')

        tag.save.should be_false
        tag.errors[:color].should_not be_empty
      end

      it "should auto save new tags on parent update" do
        tag = user.tags.new(name: 'bug', color: 'red')

        user.update(name: 'liufengyun')

        user.reload.tags.any? {|t| t.name == 'bug'}.should be_true
      end

      it "should not auto save invalid new tags on parent update" do
        tag = user.tags.new(name: 'bug')

        user.save

        user.reload.tags.any? {|t| t.name == 'bug'}.should be_false
      end

      it "should auto save new tags on parent create" do
        new_user = User.new(name: 'user')
        tag = new_user.tags.new(name: 'bug', color: 'red')

        new_user.save

        new_user.reload.tags.any? {|t| t.name == 'bug'}.should be_true
      end

      it "should not auto save invalid new tags on parent create" do
        new_user = User.new(name: 'user')
        tag = new_user.tags.new(name: 'bug')

        new_user.save

        new_user.reload.tags.any? {|t| t.name == 'bug'}.should be_false
      end
    end

    describe "update" do
      it "should be able to update record" do
        tag = user.tags.create(name: 'bug', color: 'red')

        user.reload.tags.any? {|t| t.name == 'bug'}.should be_true

        tag.update(color: 'yellow').should be_true

        user.reload.tags.any? {|t| t.color == 'yellow'}.should be_true
      end

      it "should auto save tag on parent update" do
        tag = user.tags.create(name: 'bug', color: 'red')
        tag.color = 'yellow'

        user.update(name: 'liufengyun')

        user.reload.tags.any? {|t| t.color == 'yellow'}.should be_true
      end

      it "should not auto save invalid tag on parent save" do
        tag = user.tags.create(name: 'bug', color: 'red')

        tag.color = 'yellow'
        tag.name = ''

        user.update(name: 'liufengyun')

        user.reload.tags.any? {|t| t.color == 'yellow'}.should be_false
      end
    end

    describe "destroy" do
      it "should be able to destroy" do
        tag = user.tags.create(name: 'bug', color: 'red')

        tag.destroy.should be_true

        user.reload.tags.any? {|t| t.name == 'bug'}.should be_false
      end

      it "should not be saved on parent save after destroy" do
        tag = user.tags.create(name: 'bug', color: 'red')
        tag.destroy

        user.update(name: 'liufengyun')

        user.reload.tags.any? {|t| t.color == 'yellow'}.should be_false
      end
    end

  end
end

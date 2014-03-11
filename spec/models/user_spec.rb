require 'spec_helper'

describe User do
    let(:user) { User.new(name: 'John Doe', email: 'jdoe@example.com', password: 'password') }
    subject { user }

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }

    it { should be_valid }

    describe "empty name" do
	before { user.name = '' }

	it { should_not be_valid }
    end

    describe "blank name" do
	before { user.name = ' ' }

	it { should_not be_valid }
    end

    describe "empty email" do
	before { user.email = '' }

	it { should_not be_valid }
    end

    describe "blank email" do
	before { user.email = ' ' }

	it { should_not be_valid }
    end

    describe "empty password" do
	before { user.password = '' }

	it { should_not be_valid }
    end

    describe "blank password" do
	before { user.password = ' ' }

	it { should_not be_valid }
    end
end

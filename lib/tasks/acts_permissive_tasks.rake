# desc "Explaining what the task does"
# task :acts_permissive do
#   # Task goes here
# end

desc "Create the default roles" do
  task :acts_permissive do
    puts "Loading role seed data"
    Role.create(:name => "owner", :power => '1000')
    Role.create(:name => "admin", :power => '0100')
    Role.create(:name => "write", :power => '0010')
    Role.create(:name => "read",  :power => '0001')
  end
end
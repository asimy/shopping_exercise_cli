# to keep the file structure as simple as possible, I'm creating all my classes in this file

class PurchaseReader
    def valid?(shopping_list)
        /^([a-z]+, *)*[a-z]+$/.match?(shopping_list)
    end
end
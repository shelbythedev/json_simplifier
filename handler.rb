require 'json'

class Handler

    # FUNCTION: run
    # DESCRIPTION:  Takes in a JSON object originating from a 3rd-party service.
    #               Returns a cleaned object with easy-to-manipulate key-value pairs.
    def run(req)
      # Initialize empty array for results
      results_array = []

      # Parse incoming JSON
      r = JSON.parse(req)

      # Iterate over JSON objects (Object represents one category)
      r.each do |key, val|

        # Disregard if JSON is an array
        if !val.is_a? Array
          next
        else

          # Iterate over each category object
          val.each do |cat|

            # Check name, if match, then disregard either of these categories
            next if cat['name'] == "Category to Disregard"
            next if cat['name'] == "Category to also Disregard"

            # If category has an amount,
            # push the ID and amount into a key-value pair
            if !cat['amount'].nil?
              results_array << Hash[cat['identifier'], cat['amount']]
            end

            # If parent category has children,
            # do the same process to the children
            if !cat['children'].nil?
              cat['children'].each do |t|
                results_array << Hash[t['identifier'], t['amount']]
              end
            end
          end
        end
      end

      # Take results_array and map keys and values to hash attributes
      all = Hash[results_array.map{|t| [t.keys.first, t.values.first]}]

      # return all to json and out to requesting service
      puts all.to_json
    end
end

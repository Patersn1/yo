class Ride < ApplicationRecord
    attr_reader :where_clause, :where_args, :order

	#initializes the search functionality
	# if params[:keywords].present?

	## commented out until this is fixed
	# def initialize(search_term)
	# 	if search_term.nil? then
	# 		search_term = ""
	# 	end
	# 	search_term = search_term.downcase
	# 	@where_clause = ""
	# 	@where_args = {}
	
	# 	build_search(search_term)
	# end

	private
		# search method, can find either the driver name or the event name
		# spelling has to be exact and the full word/not partial
		def build_search(search_term)
			@where_clause << search_rides(:driver_name)
            @where_args[:driver_name] = search_term
			@where_clause << " OR #{search_rides(:opportuniy_id)}"
            @where_args[:opportuniy_id] = search_term
		end
		# matches searches even if they ar not the same in terms of uppercase or lowercase
		def search_rides(ride)
			"lower(#{ride}) like :#{ride}"
		end
end

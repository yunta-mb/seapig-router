class SeapigRouterSessionSaved < Producer

	@patterns = [ 'SeapigRouter::Session::*::Saved' ]


	def self.produce(seapig_object_id)
		seapig_object_id =~ /SeapigRouter::Session::([^\:]+)::Saved/
		token = $1
		version = SeapigDependency.versions('SeapigRouter::Session::'+token)
		session = SeapigRouterSession.find_by(token: token)
		return [false, version] if not session
		max_state = session.seapig_router_session_states.select("state_id").order("state_id DESC").first
		data = {
			session_id: session.key,
			max_state_id: (max_state and max_state.state_id or -1)
		}
		[data, version]
	end

end

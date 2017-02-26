class SeapigRouterSessionStateProducer < Producer

	@patterns = [ 'SeapigRouter::Session::*::State::*' ]


	def self.produce(seapig_object_id)
		seapig_object_id =~ /SeapigRouter::Session::([^\:]+)::State::([^\:]+)/
		session_key = $1
		state_id = $2.to_i
		version = Time.new.to_f
		session = SeapigRouterSession.find_by(key: session_key)
		return [false, SeapigDependency.versions('SeapigRouter::Session::'+session_key)] if not session
		state = SeapigRouterSessionState.find_by(seapig_router_session_id: session.id, state_id: state_id)
		return [false, SeapigDependency.versions('SeapigRouter::Session::'+session_key)] if not state
		data = state.state
		[data, version]
	end

end

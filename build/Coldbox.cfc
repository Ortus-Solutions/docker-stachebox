component{

	// Configure ColdBox Application
	function configure(){

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "Stachebox",

			//Development Settings
			reinitPassword			= getSystemSetting( "REINIT_PASSWORD", ""),
			handlersIndexAutoReload = false,

			//Error/Exception Handling
			exceptionHandler		= getSystemSetting( "ENVIRONMENT", "production" ) == 'development' ? "" : "stachebox:api.v1.BaseAPIHandler.onError",
			onInvalidEvent			= getSystemSetting( "ENVIRONMENT", "production" ) == 'development' ? "" : "stachebox:api.v1.BaseAPIHandler.onInvalidRoute",
			customErrorTemplate 	= getSystemSetting( "ENVIRONMENT", "production" ) == 'development' ? "/coldbox/system/exceptions/Whoops.cfm" : "",

			//Application Aspects
			handlerCaching 			= true,
			eventCaching			= true,
			jsonPayloadToRC         = true
		};


		// Module Directives
		modules = {
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};

		//Register interceptors as an array, we need order
		interceptors = [];

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders : {
				console : { class : "coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root  : { levelmax : "ERROR", appenders : "*" }
		};

		moduleSettings = {
			"cbsecurity" : {
				"userService" : "UserService@stachebox"
			},
			"cbauth" : {
				"userServiceClass" : "UserService@stachebox"
			},
            "stachebox" : {
                "isStandalone" : true
            },
			"logstash" : {
				"applicationName" : "StacheboxContainer"
			}
		};

	}

}
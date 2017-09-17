//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// Create HTTP server.
let server = HTTPServer()

// Register your own routes and handlers
var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
		request, response in
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
		response.completed()
	}
)

routes.add(
	method: .post, uri: "/etugit/", handler: {
		request, response in
		if let bodyStr = request.postBodyString {
			print("received request body:\n\(bodyStr)")
			GitlabServant.shared.didReceived(message: bodyStr)
		}
		response.appendBody(string: "ok")
		response.completed()
	}
)

routes.add(
	method: .post, uri: "/etugit/activate_subscribe/", handler: {
		request, response in
		if let userIdStr = request.param(name: "user_id"),
			let userId = Int(userIdStr) {
			let mrFilterLabel = request.param(name: "mr_label")
			GitlabServant.shared.activate(subscriber: userId, filterLabel: mrFilterLabel)
		}
		response.appendBody(string: "ok")
		response.completed()
	}
)

routes.add(method: .get, uri: "/etugit/feed/", handler: {
		request, response in
		if let userIdStr = request.param(name: "user_id"),
			let userId = Int(userIdStr) {
			response.appendBody(string: GitlabServant.shared.getFeed(subscriber: userId))
		} else {
			response.appendBody(string: "error: no user_id")
		}
		response.completed()
	}
)

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 12322

// Set a document root.
// This is optional. If you do not want to serve static content then do not set this.
// Setting the document root will automatically add a static file handler for the route /**
server.documentRoot = "./webroot"

// Gather command line options and further configure the server.
// Run the server with --help to see the list of supported arguments.
// Command line arguments will supplant any of the values set above.
configureServer(server)

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}

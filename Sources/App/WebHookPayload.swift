//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/24/23.
//


import Foundation
import Vapor

struct WebHookPayload:Codable  {
   
    var ref:String
    var before:String
    var after:String
    var respository:Repository
    var pusher:Pusher
    var sender:Sender
    var created:Bool
    var deleted:Bool
    var forced:Bool
    var baseRef:String?
    var compare:String
    var commits:[Commit]
    var headCommit:[Commit]
    
    
    /**   "
     repository": [
     "id": 605371251,
     "node_id": "R_kgDOJBU7cw",
     "name": "secure-chat-xp",
     "full_name": "jhoughjr/secure-chat-xp",
     "private": true,
     "owner": [
       "name": "jhoughjr",
       "email": "jimmyhoughjr@me.com",
       "login": "jhoughjr",
       "id": 1562633,
       "node_id": "MDQ6VXNlcjE1NjI2MzM=",
       "avatar_url": "https://avatars.githubusercontent.com/u/1562633?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/jhoughjr",
       "html_url": "https://github.com/jhoughjr",
       "followers_url": "https://api.github.com/users/jhoughjr/followers",
       "following_url": "https://api.github.com/users/jhoughjr/following{/other_user}",
       "gists_url": "https://api.github.com/users/jhoughjr/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/jhoughjr/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/jhoughjr/subscriptions",
       "organizations_url": "https://api.github.com/users/jhoughjr/orgs",
       "repos_url": "https://api.github.com/users/jhoughjr/repos",
       "events_url": "https://api.github.com/users/jhoughjr/events{/privacy}",
       "received_events_url": "https://api.github.com/users/jhoughjr/received_events",
       "type": "User",
       "site_admin": false
     ],
     "html_url": "https://github.com/jhoughjr/secure-chat-xp",
     "description": nil,
     "fork": false,
     "url": "https://github.com/jhoughjr/secure-chat-xp",
     "forks_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/forks",
     "keys_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/keys{/key_id}",
     "collaborators_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/collaborators{/collaborator}",
     "teams_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/teams",
     "hooks_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/hooks",
     "issue_events_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/issues/events{/number}",
     "events_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/events",
     "assignees_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/assignees{/user}",
     "branches_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/branches{/branch}",
     "tags_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/tags",
     "blobs_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/git/blobs{/sha}",
     "git_tags_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/git/tags{/sha}",
     "git_refs_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/git/refs{/sha}",
     "trees_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/git/trees{/sha}",
     "statuses_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/statuses/{sha}",
     "languages_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/languages",
     "stargazers_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/stargazers",
     "contributors_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/contributors",
     "subscribers_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/subscribers",
     "subscription_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/subscription",
     "commits_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/commits{/sha}",
     "git_commits_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/git/commits{/sha}",
     "comments_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/comments{/number}",
     "issue_comment_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/issues/comments{/number}",
     "contents_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/contents/{+path}",
     "compare_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/compare/{base}...{head}",
     "merges_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/merges",
     "archive_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/{archive_format}{/ref}",
     "downloads_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/downloads",
     "issues_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/issues{/number}",
     "pulls_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/pulls{/number}",
     "milestones_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/milestones{/number}",
     "notifications_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/notifications{?since,all,participating}",
     "labels_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/labels{/name}",
     "releases_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/releases{/id}",
     "deployments_url": "https://api.github.com/repos/jhoughjr/secure-chat-xp/deployments",
     "created_at": 1677119190,
     "updated_at": "2023-02-23T02:26:37Z",
     "pushed_at": 1677256519,
     "git_url": "git://github.com/jhoughjr/secure-chat-xp.git",
     "ssh_url": "git@github.com:jhoughjr/secure-chat-xp.git",
     "clone_url": "https://github.com/jhoughjr/secure-chat-xp.git",
     "svn_url": "https://github.com/jhoughjr/secure-chat-xp",
     "homepage": nil,
     "size": 35,
     "stargazers_count": 0,
     "watchers_count": 0,
     "language": "Swift",
     "has_issues": true,
     "has_projects": true,
     "has_downloads": true,
     "has_wiki": true,
     "has_pages": false,
     "has_discussions": false,
     "forks_count": 0,
     "mirror_url": nil,
     "archived": false,
     "disabled": false,
     "open_issues_count": 0,
     "license": nil,
     "allow_forking": true,
     "is_template": false,
     "web_commit_signoff_required": false,
     "topics": [

     ],
     "visibility": "private",
     "forks": 0,
     "open_issues": 0,
     "watchers": 0,
     "default_branch": "main",
     "stargazers": 0,
     "master_branch": "main"
   ],*/
    
    struct Repository:Codable {
        var id:Int
        var nodeID:String
        var name:String
        var fullName:String
        var pivate:Bool
        var owner:Owner
        var html_url: String
        var description: String?
        var fork: Bool
        var url: String
        var forks_url: String
        var keys_url:String
        var collaborators_url:String
        var teams_url: String
        var hooks_url:String
        var issue_events_url: String
        var events_url:String
        var assignees_url: String
        var branches_url:String
        var tags_url: String
        var blobs_url: String
        var git_tags_url:String
        var git_refs_url:String
        var trees_url: String
        var statuses_url: String
        var languages_url: String
        var stargazers_url: String
        var contributors_url: String
        var subscribers_url: String
        var subscription_url:String
        var commits_url: String
        var git_commits_url:String
        var comments_url: String
        var issue_comment_url: String
        var contents_url: String
        var compare_url: String
        var merges_url: String
        var archive_url: String
        var downloads_url: String
        var issues_url: String
        var pulls_url: String
        var milestones_url: String
        var notifications_url: String
        var labels_url: String
        var releases_url: String
        var deployments_url: String
        var created_at: Int
        var updated_at: String
        var pushed_at: Int
        var git_url: String
        var ssh_url: String
        var clone_url: String
        var svn_url: String
        var homepage:String?
        var size: Int
        var stargazers_count: Int
        var watchers_count:Int
        var language:String
        var has_issues:Bool
        var has_projects: Bool
        var has_downloads:Bool
        var has_wiki:Bool
        var has_pages: Bool
        var has_discussions:Bool
        var forks_count: Int
        var mirror_url:String?
        var archived:Bool
        var disabled:Bool
        var open_issues_count:Int
        var license:String?
        var allow_forking:Bool
        var is_template:Bool
        var web_commit_signoff_required: Bool
        var topics: [String?]
        var visibility:String
        var forks:Int
        var open_issues:Int
        var watchers:Int
        var default_branch: String
        var stargazers:Int
        var master_branch:String
        
    }
    
    struct Owner:Codable {
        var name: String
        var email: String
        var login:String
        var id: Int
        var node_id: String
        var avatar_url: String
        var gravatar_id:String
        var url: String
        var html_url: String
        var followers_url: String
        var following_url:String
        var gists_url: String
        var starred_url: String
        var subscriptions_url:String
        var organizations_url: String
        var repos_url: String
        var events_url: String
        var received_events_url:String
        var type:String
        var site_admin:Bool
    }

    /**
     "pusher": [
       "name": "jhoughjr",
       "email": "jimmyhoughjr@me.com"
     ],
     **/
    struct Pusher:Codable {
        let name:String
        let email:String
    }
    
    /**
     "sender": [
       "login": "jhoughjr",
       "id": 1562633,
       "node_id": "MDQ6VXNlcjE1NjI2MzM=",
       "avatar_url": "https://avatars.githubusercontent.com/u/1562633?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/jhoughjr",
       "html_url": "https://github.com/jhoughjr",
       "followers_url": "https://api.github.com/users/jhoughjr/followers",
       "following_url": "https://api.github.com/users/jhoughjr/following{/other_user}",
       "gists_url": "https://api.github.com/users/jhoughjr/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/jhoughjr/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/jhoughjr/subscriptions",
       "organizations_url": "https://api.github.com/users/jhoughjr/orgs",
       "repos_url": "https://api.github.com/users/jhoughjr/repos",
       "events_url": "https://api.github.com/users/jhoughjr/events{/privacy}",
       "received_events_url": "https://api.github.com/users/jhoughjr/received_events",
       "type": "User",
       "site_admin": false
     **/
    struct Sender:Codable {
        let login:String
        let id:Int
        let nodeID:String
        let avatarURL:String
        let gravatarID:String
        let url:String
        let htmlURL:String
        let followersURL:String
        let followingURL:String
        let gistsURL:String
        let starredURL:String
        let subscriptionsURL:String
        let organizationsURL:String
        let reposURL:String
        let eventsURL:String
        let receivedEvevntsURL:String
        let type:String
        let siteAdmin:Bool
    }
    
    /** "author": [
     "name": "Jimmy Hough",
     "email": "jimmyhoughjr@me.com",
     "username": "jhoughjr"
   ],
   */
    struct Author:Codable {
        let name:String
        let email:String
        let username:String
    }
    
    /**"committer": [
     "name": "Jimmy Hough",
     "email": "jimmyhoughjr@me.com",
     "username": "jhoughjr"
   ],*/
    struct Committer:Codable {
        let name:String
        let email:String
        let username:String
    }
    
    /**
     "commits": [
       [
         "id": "12543801886c7cd09ab9d36a5646447470063bac",
         "tree_id": "dcb65a225bab7a7096900342ed9e555c5aaa10b6",
         "distinct": true,
         "message": "more test",
         "timestamp": "2023-02-24T10:35:15-06:00",
         "url": "https://github.com/jhoughjr/secure-chat-xp/commit/12543801886c7cd09ab9d36a5646447470063bac",
         "author": [
           "name": "Jimmy Hough",
           "email": "jimmyhoughjr@me.com",
           "username": "jhoughjr"
         ],
         "committer": [
           "name": "Jimmy Hough",
           "email": "jimmyhoughjr@me.com",
           "username": "jhoughjr"
         ],
         "added": [

         ],
         "removed": [

         ],
         "modified": [
           "foo.text"
         ]
       ]
     ]
     */
    struct Commit:Codable {
        let id:String
        let treeID:String
        let distinct:Bool
        let message:String
        let timestamp:String
        let url:String
        let author:Author
        let commiter:Committer
        let added:[String]
        let removed:[String]
        let modified:[String]
    }
}

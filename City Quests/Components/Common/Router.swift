//
//  Router.swift
//  HalaMotor
//
//  Created by mac on 22/08/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

enum Router: String {
    
//    static let BASE_SERVICE_URL = "http://appsmsjuegos.com/Quiz/webservice/"
//    static let BASE_IMAGE_URL = "https://appsmsjuegos.com/uploads/images/"
    
    static let BASE_SERVICE_URL = "https://appsmsjuegos.com/Quiz/QuizUSA/webservice/"
    static let BASE_IMAGE_URL = "https://appsmsjuegos.com/Quiz/QuizUSA/uploads/images/"

    
    
    case logIn
    case signUp
    case get_term_conditions
    case forgot_password
    case get_profile
    case update_profile
    case get_banner
    case get_event
    case event_apply_code
    case change_password
    case add_contact_us
    case event_start_time
    case get_event_details
    case get_my_event
    case get_event_instructions_game
    case event_instructions_game_ans
    case add_hint
    case get_all_inventory_event
    case event_end_time
    case get_event_finish_time
    case get_all_event_finish_time
    case virus_event_apply_code
    case get_event_code
    case virus_event_start_time
    case get_virus_event_answer_new
    case add_virus_hint
    case add_virus_event_ans
    case get_event_finish_time_game4
    case virus_event_end_time
    case account_delete
    case get_inventory_event
    case get_event_time
    case get_event_instructions_game_images
    case event_start_time_game4
    case get_level
    case get_Accomplishments
    case get_finish_event_by_event
    case event_pause_time


    public func url() -> String {
        switch self {
        case .logIn:
            return Router.oAuthRoute(path: "login?")
        case .signUp:
            return Router.oAuthRoute(path: "signup?")
        case .get_term_conditions:
            return Router.oAuthRoute(path: "get_term_conditions")
        case .forgot_password:
            return Router.oAuthRoute(path: "forgot_password")
        case .get_profile:
            return Router.oAuthRoute(path: "get_profile")
        case .update_profile:
            return Router.oAuthRoute(path: "update_profile")
        case .get_banner:
            return Router.oAuthRoute(path: "get_banner")
        case .get_event:
            return Router.oAuthRoute(path: "get_event")
        case .event_apply_code:
            return Router.oAuthRoute(path: "event_apply_code")
        case .change_password:
            return Router.oAuthRoute(path: "change_password")
        case .add_contact_us:
            return Router.oAuthRoute(path: "add_contact_us")
        case .event_start_time:
            return Router.oAuthRoute(path: "event_start_time")
        case .get_event_details:
            return Router.oAuthRoute(path: "get_event_details")
        case .get_my_event:
            return Router.oAuthRoute(path: "get_my_event")
        case .get_event_instructions_game:
            return Router.oAuthRoute(path: "get_event_instructions_game")
        case .event_instructions_game_ans:
            return Router.oAuthRoute(path: "event_instructions_game_ans")
        case .add_hint:
            return Router.oAuthRoute(path: "add_hint")
        case .get_all_inventory_event:
            return Router.oAuthRoute(path: "get_all_inventory_event")
        case .event_end_time:
            return Router.oAuthRoute(path: "event_end_time")
        case .get_event_finish_time:
            return Router.oAuthRoute(path: "get_event_finish_time")
        case .get_all_event_finish_time:
            return Router.oAuthRoute(path: "get_all_event_finish_time")
        case .virus_event_apply_code:
            return Router.oAuthRoute(path: "virus_event_apply_code")
        case .get_event_code:
            return Router.oAuthRoute(path: "get_event_code")
        case .virus_event_start_time:
            return Router.oAuthRoute(path: "virus_event_start_time")
        case .get_virus_event_answer_new:
            return Router.oAuthRoute(path: "get_virus_event_answer_new")
        case .add_virus_hint:
            return Router.oAuthRoute(path: "add_virus_hint")
        case .add_virus_event_ans:
            return Router.oAuthRoute(path: "add_virus_event_ans")
        case .get_event_finish_time_game4:
            return Router.oAuthRoute(path: "get_event_finish_time_game4")
        case .virus_event_end_time:
            return Router.oAuthRoute(path: "virus_event_end_time")
        case .account_delete:
            return Router.oAuthRoute(path: "account_delete")
        case .get_inventory_event:
            return Router.oAuthRoute(path: "get_inventory_event")
        case .get_event_time:
            return Router.oAuthRoute(path: "get_event_time")
        case .get_event_instructions_game_images:
            return Router.oAuthRoute(path: "get_event_instructions_game_images")
        case .event_start_time_game4:
            return Router.oAuthRoute(path: "event_start_time_game4")
        case .get_level:
            return Router.oAuthRoute(path: "get_level")
        case .get_Accomplishments:
            return Router.oAuthRoute(path: "get_Accomplishments")
        case .get_finish_event_by_event:
            return Router.oAuthRoute(path: "get_finish_event_by_event")
        case .event_pause_time:
            return Router.oAuthRoute(path: "event_pause_time")

        }
    }
    
    private static func oAuthRoute(path: String) -> String {
        return Router.BASE_SERVICE_URL + path
    }
    
}

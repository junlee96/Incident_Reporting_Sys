//
//  TasklistDetails.swift
//  Incident Reporting System
//
//  Created by Admin on 27/4/16.
//  Copyright © 2016 Dreamsmart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum TaskFields: String {
    case taskId = "task_id"
    case taskName = "task_name"
    case taskChecked = "task_checked"
    case taskSubmittedDate = "task_submitted_date"
    case taskComment = "task_comment"
    case taskBuildingLevel = "task_building_level"
    case taskDescription = "task_description"
    case taskStatus = "task_status"
    case totalRating = "total_rating"
    case safetyRating = "safety_rating"
    case photos = "photos"
}

enum SafetyFields: String {
    case safetyId = "safety_rating_id"
    case safetyTaskId = "task_id"
    case safetyName = "name"
    case safetyPoints = "points"
    case safetyScore = "score"
}

class TasklistWrapper {
    private var jobId: Int?
    private var startDate: NSDate?
    private var endDate: NSDate?
    private var buildingId: Int?
    private var buildingName: String?
    private var blockNumber: String?
    private var streetName: String?
    private var postalCode: Int?
    private var checklistId: Int?
    private var checklistName: String?
    private var checklistDueDate: NSDate?
    var tasks: Array<TasklistDetails>?
}



class TasklistDetails {
    var idNumber: Int?
    var taskId: Int?
    var taskName: String?
    var taskChecked: Bool?
    var taskSubmittedDate: NSDate?
    var taskComment: String?
    var taskBuildingLevel: Int?
    var taskDescription: String?
    var taskStatus: String?
    var totalRating: Int?
    var safetyRating: Array<SafetyRatingDetails>?
    var photos: Array<String>?
    

    required init(json: JSON, id: Int?) {
        print(json)
        self.idNumber = id
        
        //Strings
        self.taskName = json[TaskFields.taskName.rawValue].stringValue
        self.taskComment = json[TaskFields.taskComment.rawValue].stringValue
        self.taskDescription = json[TaskFields.taskDescription.rawValue].stringValue
        self.taskStatus = json[TaskFields.taskStatus.rawValue].stringValue
        
        //Bool
        self.taskChecked = json[TaskFields.taskChecked.rawValue].boolValue
        
        //Ints
        self.taskId = json[TaskFields.taskId.rawValue].intValue
        self.taskBuildingLevel = json[TaskFields.taskBuildingLevel.rawValue].intValue
        self.totalRating = json[TaskFields.totalRating.rawValue].intValue
        
        // arrays
        // there are arrays of JSON objects, so we need to extract the strings from them
        if let jsonArray = json[TaskFields.photos.rawValue].array
        {
            self.photos = Array<String>()
            for entry in jsonArray
            {
                self.photos?.append(entry.stringValue)
            }
        }

        // Dates
        let dateFormatter = checklistConstants.dateFormatter()
        if let dateString = json[TaskFields.taskSubmittedDate.rawValue].string
        {
            self.taskSubmittedDate = dateFormatter.dateFromString(dateString)
        }
    }
    
    // MARK: Endpoints
    
    class func endpointForTasks() -> String {
        return "http://inciden.shrimpventures.com/api/v1/users/5/schedule_jobs/weekly/tasks"
    }
}

class SafetyRatingDetails {
        var safetyRatingId: Int?
        var safetyId: Int?
        var safetyTaskId: Int?
        var safetyName: String?
        var safetyPoints: Int?
        var safetyScore: Int?
        
        required init(json: JSON, id: Int?) {
            print(json)
            self.safetyRatingId = id
            
            //Strings
            self.safetyName = json[SafetyFields.safetyName.rawValue].stringValue
            
            //Ints
            self.safetyId = json[SafetyFields.safetyId.rawValue].intValue
            self.safetyTaskId = json[SafetyFields.safetyTaskId.rawValue].intValue
            self.safetyPoints = json[SafetyFields.safetyPoints.rawValue].intValue
            self.safetyScore = json[SafetyFields.safetyScore.rawValue].intValue
            
        }
    
}

extension Alamofire.Request {
    func responseTasksArray(completionHandler: Response<TasklistWrapper, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<TasklistWrapper, NSError> { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            guard let responseData = data else {
                let failureReason = "Array could not be serialized because input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            //get data as JSON
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)

            switch result {
                
            case .Success(let value):
                
                //grabs the top level fields for pagination
                let json = SwiftyJSON.JSON(value)
                let wrapper = TasklistWrapper()
                
                //Strings
                wrapper.buildingName = json["building_name"].stringValue
                wrapper.blockNumber = json["building_block_no"].stringValue
                wrapper.checklistName = json["checklist_name"].stringValue
                
                //Int values
                wrapper.jobId = json["schedule_job_id"].intValue
                wrapper.buildingId = json["building_id"].intValue
                wrapper.postalCode = json["building_postal_code"].intValue
                wrapper.checklistId = json["checklist_id"].intValue
                
                // Dates
                //start date, end date and checklist due date
                let dateFormatter = checklistConstants.dateFormatter()
                if let dateString = json["start_date"].string
                {
                    wrapper.startDate = dateFormatter.dateFromString(dateString)
                }
                if let dateString = json["end_date"].string
                {
                    wrapper.endDate = dateFormatter.dateFromString(dateString)
                }
                if let dateString = json["checklist_due_date"].string
                {
                    wrapper.checklistDueDate = dateFormatter.dateFromString(dateString)
                }
                        

                //digs down to the tasks element whose contents get parsed into an array of checklist objects
                var allTasks:Array = Array<TasklistDetails>()
                print(json)
                let tasks = json["tasks"]
                print(tasks)
                for (index, jsonTasks) in tasks {
                    let taskItems = TasklistDetails(json: jsonTasks, id: Int(index))
                    allTasks.append(taskItems)
                }
                wrapper.tasks = allTasks
                return .Success(wrapper)
                
                
            case .Failure(let error):
                return .Failure(error)
            }        }
        
        return response(responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}

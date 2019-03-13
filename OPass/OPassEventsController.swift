//
//  OPassEventsController.swift
//  OPass
//
//  Created by 腹黒い茶 on 2019/3/2.
//  Copyright © 2019 OPass. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import then
import Nuke

class OPassEventsController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var progress: MBProgressHUD = MBProgressHUD.init()
    var opassEvents: Array<EventShortInfo> = Array<EventShortInfo>()
    var firstLoad: Bool = true
    @IBOutlet weak var veView: UIVisualEffectView!
    @IBOutlet weak var eventsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.progress.removeFromSuperViewOnHide = false
        self.progress.mode = .indeterminate
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.progress.show(animated: true)
        OPassAPI.CleanupEvents()
        self.opassEvents.removeAll()
        self.eventsTable.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OPassAPI.GetEvents({ retryCount, retryMax, error, responsed in
            self.progress.label.text = "[\(retryCount)/\(retryMax)] \(error.localizedDescription)"
        }).then { (events: Array<EventShortInfo>) in
            self.opassEvents = events
            }.then { _ in
                if self.firstLoad {
                    self.veView.alpha = 0
                    self.veView.isHidden = false
                }
                UIView.animate(withDuration: 1, animations: {
                    self.veView.alpha = 1
                }, completion: { (finished: Bool) in
                    self.eventsTable.reloadData()
                })
            }.then { _ in
                self.progress.label.text = ""
                self.progress.hide(animated: true)
            }.then { _ in
                if self.firstLoad && self.opassEvents.count == 1 {
                    let _ = self.LoadEvent(self.opassEvents.first!.EventId)
                    self.firstLoad = false
                }
        }
    }

    func LoadEvent(_ eventId: String) -> Promise<()> {
        self.progress.show(animated: true)
        let e = OPassAPI.SetEvent(eventId, { retryCount, retryMax, error, responsed in
            self.progress.label.text = "[\(retryCount)/\(retryMax)] \(error.localizedDescription)"
        }).then { (event: EventInfo) in
            self.progress.label.text = ""
            self.progress.hide(animated: true)
            if Constants.HasSetEvent {
                self.performSegue(withIdentifier: "OPassTabView", sender: event)
            }
        }
        return e
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.opassEvents.count
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as OPassEventCell = cell else {
            return
        }

        cell.unfold(false, animated: false, completion: nil)
//        if cellHeights[indexPath.row] == Const.closeCellHeight {
//            cell.unfold(false, animated: false, completion: nil)
//        } else {
//            cell.unfold(true, animated: false, completion: nil)
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCellName = "OPassEvent"
        var cell: OPassEventCell? = self.eventsTable.dequeueReusableCell(withIdentifier: eventCellName) as? OPassEventCell
        if (cell == nil) {
            let eventNib = UINib.init(nibName: "OPassEventCell", bundle: nil)
            self.eventsTable.register(eventNib, forCellReuseIdentifier: eventCellName)
            cell = self.eventsTable.dequeueReusableCell(withIdentifier: eventCellName) as? OPassEventCell
        }
        let event = self.opassEvents[indexPath.row]
        cell!.EventId = event.EventId
        cell!.EventName.text = event.DisplayName.zh
        Nuke.loadImage(
            with: event.LogoUrl,
            options: ImageLoadingOptions(
                placeholder: Constants.AssertImage("PassAssets", "StaffIconDefault"),
                transition: .fadeIn(duration: 0.33)
            ),
            into: cell!.EventLogo
        )
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell!.durationsForExpandedState = durations
        cell!.durationsForCollapsedState = durations
        return cell!
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OPassEventCell
        let _ = self.LoadEvent(cell.EventId)
    }

}

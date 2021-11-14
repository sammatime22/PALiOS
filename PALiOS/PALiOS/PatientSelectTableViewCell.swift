//
//  PatientSelectTableViewCell.swift
//  PALiOS
//
//  Created by sammatime22 on 3/24/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit

class PatientSelectTableViewCell: UITableViewCell {

  //MARK: Properties
  @IBOutlet var PatientNameAndID: UILabel!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

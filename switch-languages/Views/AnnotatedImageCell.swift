//
//  AnnotatedImageCell.swift
//  switch-languages
//
//  Created by Andrew Fletcher on 30/10/20.
//

import UIKit


class AnnotatedImageCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
}

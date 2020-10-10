//
//  DHSanboxNodeCell.swift
//  Pods
//
//  Created by iblue on 2020/10/9.
//

import UIKit

class DHSanboxNodeCell: UITableViewCell {
    
    /// 节点图标
    lazy var nodeTypeIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 节点名称
    lazy var nodeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    /// 节点大小
    lazy var nodeSizeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(nodeTypeIcon)
        contentView.addSubview(nodeTitleLabel)
        contentView.addSubview(nodeSizeLabel)
        
        let cellHeight = DHSanboxNodeCell.height()
        var width: CGFloat = 30
        nodeTypeIcon.frame = CGRect(x: 10, y: (cellHeight - width) / 2.0, width: width, height: width)
        
        var x: CGFloat = nodeTypeIcon.frame.maxX + 15
        width = UIScreen.main.bounds.width - x - 150
        nodeTitleLabel.frame = CGRect(x: x, y: 0, width: width, height: cellHeight)
        
        x = UIScreen.main.bounds.width - 150
        width = 120
        nodeSizeLabel.frame = CGRect(x: x, y: 0, width: width, height: cellHeight)
    }
    
    func configureCell(data: DHSanboxNodeModel) {
        if data.nodeType == .directory {
            nodeTypeIcon.image = Bundle.dh_sandboxBundleImage(named: "sandbox_dir")
            nodeTitleLabel.textColor = UIColor.darkGray
        } else if data.nodeType == .file {
            nodeTypeIcon.image = Bundle.dh_sandboxBundleImage(named: "sandbox_file_text")
            nodeTitleLabel.textColor = UIColor.darkGray
        } else {
            nodeTypeIcon.image = Bundle.dh_sandboxBundleImage(named: "sandbox_back")
            nodeTitleLabel.textColor = UIColor.systemBlue
        }
        
        nodeTitleLabel.text = data.name
        nodeSizeLabel.text = data.size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Static
    static func identifier() -> String {
        return "DHSanboxNodeCell"
    }
    
    static func height() -> CGFloat {
        return 48.0
    }
}

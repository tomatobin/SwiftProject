//
//  DHSandBoxViewController.swift
//  DHSanboxTool
//
//  Created by iblue on 2020/10/9.
//

import UIKit
import QuickLook

public class DHSandBoxViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView: UITableView!
    
    /// 当前节点数据
    var currentNode: DHSanboxNodeModel!
    
    /// 根路径
    var rootNode: DHSanboxNodeModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initTableView()
        initData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func initTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DHSanboxNodeCell.classForCoder(), forCellReuseIdentifier: DHSanboxNodeCell.identifier())
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    //MARK: - Init Data
    func initData() {
        rootNode = DHSandboxUtil.getSandboxNode(targetPath: NSHomeDirectory())
        loadSubNodeData(node: rootNode)
    }
    
    /// 加载子节点数据，并保存当前节点、父节点的信息
    /// - Parameter node: 节点
    func loadSubNodeData(node: DHSanboxNodeModel) {
        currentNode = node
        DHSandboxUtil.generateSubNodes(node: currentNode)
        tableView.reloadData()
        updateVCTitle()
    }
    
    /// 加载父节点数据，并保存当前节点、父节点的信息
    /// - Parameter node: 节点
    func loadParentNodeData(node: DHSanboxNodeModel) {
        if node.parentNode?.parentNode != nil {
            currentNode = node.parentNode?.parentNode
        } else if node.parentNode != nil {
            currentNode = node.parentNode
        }
       
        
        tableView.reloadData()
        updateVCTitle()
    }
    
    func updateVCTitle() {
        if currentNode.name.count > 0 {
            title = currentNode.name
        } else {
            title = "沙盒浏览器"
        }
    }
    
    //MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DHSanboxNodeCell.height()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentNode?.subNodes?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DHSanboxNodeCell.identifier(), for: indexPath)
        guard let count = currentNode.subNodes?.count, indexPath.row < count else {
            return cell
        }
        
        let nodeCell: DHSanboxNodeCell = cell as! DHSanboxNodeCell
        let node = currentNode.subNodes![indexPath.row]
        nodeCell.configureCell(data: node)
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let count = currentNode.subNodes?.count, indexPath.row < count else {
            return
        }
        
        let node = currentNode.subNodes![indexPath.row]

        //目录进入下一级；文件进行操作
        if node.nodeType == .directory {
            loadSubNodeData(node: node)
        } else if node.nodeType == .back {
            loadParentNodeData(node: node)
        } else {
            showFileOperation(filePath: node.path)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //一级目录不允许删除
        return currentNode.parentNode != nil
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        guard let count = currentNode.subNodes?.count, indexPath.row < count else {
            return
        }
        
        //删除文件、节点
        let node = currentNode.subNodes![indexPath.row]
        try? FileManager.default.removeItem(atPath: node.path)
        
        currentNode.subNodes?.removeAll(where: { (object) -> Bool in
            return object.path == node.path
        })
        
        tableView.reloadData()
    }
    
    //MARK: - Open File or Share
    func showFileOperation(filePath: String) {
        let alertVc = UIAlertController(title: "请选择操作方式", message: "", preferredStyle: .actionSheet)
        weak var weakSelf = self
        let previewAction = UIAlertAction(title: "文件预览", style: .default) { (_) in
            weakSelf?.previewFile(path: filePath)
        }
        
        let shareAction = UIAlertAction(title: "分享", style: .default) { (_) in
            weakSelf?.shareFile(path: filePath)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        
        alertVc.addAction(previewAction)
        alertVc.addAction(shareAction)
        alertVc.addAction(cancelAction)
        
        present(alertVc, animated: true, completion: nil)
    }
    
    func previewFile(path: String) {
        if !DHSandboxFilePreviewData.canpreview(filePath: path) {
            DHSandboxUtil.showAlert(message: "暂不支持该类型文件的预览!", fromVC: self)
            return
        }
        
        let previewVc = QLPreviewController()
        let dataSource = DHSandboxFilePreviewData()
        dataSource.filePath = path
        previewVc.dataSource = dataSource
        present(previewVc, animated: true, completion: nil)
    }
    
    func shareFile(path: String) {
        let fileUrl = URL(fileURLWithPath: path)
        DHSandboxUtil.share(object: fileUrl, fromVC: self)
    }
}


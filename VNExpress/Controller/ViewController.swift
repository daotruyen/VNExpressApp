//
//  ViewController.swift
//  VNExpress
//
//  Created by Tuyen on 05/07/2021.
//

import UIKit
import SwiftSoup
import SafariServices
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate,SFSafariViewControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource{
    
    var pickDone : ((_ url: String, _ name: String)->Void)?
    //collection cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChannelName.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! TabCollectionViewCell
        collection.label?.text = ChannelName.element(at: indexPath.row)?.rawValue
        return collection
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let channel = ChannelURL.element(at: indexPath.row), let pickDone = pickDone, let name = ChannelName.element(at: indexPath.row)?.rawValue{
            pickDone(channel.rawValue, name)
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    var channel : NSArray = []
    var news: NSArray = []
    var linkHrefImg = ""
    var currentLink:String = ""
    var url: URL!
    var link:String = ""
    var urlString: String = "https://vnexpress.net/rss/tin-moi-nhat.rss"
    
    // table Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let contents = (news.object(at: indexPath.row) as AnyObject).object(forKey: "description") as! String
        let text: String
        do{
            let doc: Document = try SwiftSoup.parse(contents)
            
             if let a:Element = try doc.select("a").first() {
                link = try a.attr("href")
               // print(link)
             }
            
            
            let image: Element? = try doc.select("img").first()
            if let image = image{
                linkHrefImg = try image.attr("src")
            }else{
                linkHrefImg = (currentLink != "") ? currentLink : "https://i1-kinhdoanh.vnecdn.net/2021/07/05/w1-1625475344-8362-1625476036.jpg?w=1200&h=0&q=100&dpr=1&fit=crop&s=yaNdI4NabU_nwn6Ynoy_Kg"
                            }
            //linkImage = try image.attr("src")
            //print(linkImage)
            text = try doc.body()!.text();
            //print(text)
        }
        catch{
            return MainTableViewCell()
        }
        
        //prprint((news.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String as Any)
        
        let cell = TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        let url = NSURL(string: (linkHrefImg))
        
        if let data = NSData(contentsOf:url! as URL)
        {
            let image = UIImage(data:(data) as Data)
            cell.newImage?.image = image
        }

        cell.newTitle.text = (news.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String
        cell.newTime.text = "\(((news.object(at: indexPath.row) as AnyObject).object(forKey: "pubDate") as! String).toDate?.toHourAgo ?? "") phút trước "
        cell.newDescription.text = text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: link) else {
                return
            }
        let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    
    //web
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var TableView: UITableView!
   
    @IBAction func reload(_ sender: Any) {
        loadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "News"
        CollectionView.delegate = self
        CollectionView.dataSource = self
        TableView.delegate = self
        TableView.dataSource = self
        
        
        setupSideMenu()
        loadData()
    }
    
    //request data
    func loadData(){
        url = URL(string: urlString)!
        let myParser : RssParse = RssParse().initWithUrl(url) as! RssParse
        //trend = myParser.image
        news = myParser.news
        TableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setupSideMenu(){
        pickDone = {(url, name) in
            self.urlString = url
            self.loadData()
            self.title = name
            
        }
      }
}
extension String {
    var toDate: Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, dd/MM/yyyy: HH:mm:ss Z"
            return dateFormatter.date(from: self)
        }
        
}
extension Date {
    var toHourAgo: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m"
        return dateFormatter.string(from: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - self.timeIntervalSince1970))
    }
}



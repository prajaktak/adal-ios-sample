//
//  ViewController.swift
//  LocationServiceiOSClient
//
//  Created by Prajakta Kulkarni on 29/03/16.
//  Copyright © 2016 Sarang Kulkarni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let aadInstance:String = "https://login.microsoftonline.com/"
    @IBOutlet weak var resultTextView: UITextView!
    let tenant:String = "sarangbk.onmicrosoft.com"
    let clientId:String = "0bcbe0a7-004f-4a5a-9cb2-a768af2fff51"
    
    var redirectUri:NSURL = NSURL(string: "http://iosendpoint/")!
    
    var authoriry:String = ""
//    var authContext:ADAuthenticationContext
    var authResult:ADAuthenticationResult!
    
    var serviceResourceId:String = "https://locationservicewebapi.azurewebsites.net/"
    //private static string serviceBaseAddress = "https://localhost:44300/";
    let serviceBaseAddress:String = "https://locationservicewebapi.azurewebsites.net/"
    var httpClient:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string:"https://locationservicewebapi.azurewebsites.net//api/location?cityName=dc")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authoriry = String(format:"%@%@",aadInstance, tenant)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonClicked(sender: AnyObject)
    {
        
        let button:UIButton = sender as! UIButton
        if(button.currentTitle == "Sign Out")
        {
            var error: ADAuthenticationError?
            let cache: ADTokenCacheStoring = ADAuthenticationSettings.sharedInstance().defaultTokenCacheStore
            
            // Clear the token cache
            let allItemsArray = cache.allItemsWithError(&error)
            if (!allItemsArray.isEmpty) {
                cache.removeAllWithError(&error)
            }
            
            // Remove all the cookies from this application's sandbox. The authorization code is stored in the
            // cookies and ADAL will try to get to access tokens based on auth code in the cookie.
            let cookieStore = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            if let cookies = cookieStore.cookies {
                for cookie in cookies {
                    cookieStore.deleteCookie(cookie )
                }
            }
            self.resultTextView.text = ""
            button.setTitle("Sign In", forState: .Normal)
        }
        else
        {
            var er:ADAuthenticationError? = nil
            let authContext:ADAuthenticationContext = ADAuthenticationContext(authority: authoriry, error:&er)
        
            authContext.acquireTokenWithResource(serviceResourceId, clientId: clientId, redirectUri: redirectUri) {
                (result:ADAuthenticationResult!) -> Void in
                self.authResult = result
                if(result.accessToken == nil)
                {
                    print("token is empty")
                    self.resultTextView.text = "token is empty"
                }
                else
                {
                    print("accessToken : \(result.accessToken)")
                    self.resultTextView.text = "accessToken : \(result.accessToken)"
                    button.setTitle("Sign Out", forState: .Normal)
                }
            }
        }
        
    }
    
    @IBAction func callWebApiButtonClicked(sender: AnyObject)
    {
        
        if(self.authResult == nil)
        {
            self.resultTextView.text = "Please sign in first"
        }
        else
        {
            httpClient.setValue("Bearer: \(self.authResult.accessToken)", forHTTPHeaderField: "Authentication")
            NSURLConnection.sendAsynchronousRequest(httpClient, queue:NSOperationQueue.mainQueue(), completionHandler: { (response, data, err) -> Void in
                self.resultTextView.text =  String(data: data!, encoding: NSUTF8StringEncoding)
        })
        }
        
//        if(authResult == null)
//        {
//            serviceResult.Text = "Please sign in first";
//        }
//        try
//            {
//                authResult = authContext.AcquireToken(serviceResourceId, clientId, redirectUri, PromptBehavior.Never); // Never because we are assuming Refresh token is present and we are reusing that
//                
//        }
//        catch(AdalException ex)
//        {
//            serviceResult.Text = ex.ToString();
//            return;
//        }
//        
//        httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", authResult.AccessToken);
//        
//        HttpResponseMessage responce = await httpClient.GetAsync(serviceBaseAddress + "api/location?cityName=dc");
//        if (responce.IsSuccessStatusCode)
//        {
//            string s = await responce.Content.ReadAsStringAsync();
//            serviceResult.Text = s;
//        }
//        else
//        {
//            serviceResult.Text = responce.ReasonPhrase;
//        }
    }
    
    

}


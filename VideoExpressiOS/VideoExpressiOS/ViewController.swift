//
//  ViewController.swift
//  VideoExpressiOS
//
//  Created by Abdulhakim Ajetunmobi on 31/08/2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let sessionButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = "Get Session"
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let joinButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = "Join Session"
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 24
        return sv
    }()
    
    private let progressView: UIActivityIndicatorView = {
        let pv = UIActivityIndicatorView(style: .large)
        pv.isHidden = true
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    private var isLoading = false {
        didSet {
            toggleLoading()
        }
    }
    
    private var session: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {

            }
        }
    }

    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(progressView)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(sessionButton)
        stackView.addArrangedSubview(joinButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        navigationItem.title = "Video Express"
        sessionButton.addTarget(self, action: #selector(sessionButtonTapped), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    private func toggleLoading() {
        DispatchQueue.main.async { [self] in
            progressView.isHidden = !isLoading
            progressView.startAnimating()
            stackView.isHidden = isLoading
            
            if self.session != nil {
                statusLabel.text = "Session ID: \(self.session!)"
                self.sessionButton.isHidden = true
                progressView.stopAnimating()
                self.joinButton.isHidden = false
            }
        }
    }
    
    @objc private func sessionButtonTapped() {
        isLoading = true
        Task {
            self.session = await getSession()
            isLoading = false
        }
    }
    
    @objc private func joinButtonTapped() {
        let videoViewController = VideoExpressViewController(session: self.session!)
        navigationController?.pushViewController(videoViewController, animated: true)
    }
    
    private func getSession() async -> String {
        var request = URLRequest(url: URL(string: "\(AppDelegate.baseUrl)/session")!)
        request.httpMethod = "GET"
        let (data, _) = try! await URLSession.shared.data(for: request)
        return try! JSONDecoder().decode(SessionData.self, from: data).session
    }

}

struct SessionData: Codable {
    let session: String
}


//
//  PDFViewController.swift
//  BookXpertProject
//
//  Created by sona on 19/05/25.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var pdfContainerView: UIView!
        override func viewDidLoad() {
            super.viewDidLoad()
            loadPDF()
        }

        func loadPDF() {
            guard let url = URL(string: "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf") else {
                return
            }

            let pdfView = PDFView(frame: pdfContainerView.bounds)
            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            pdfView.autoScales = true
            pdfContainerView.addSubview(pdfView)

            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let document = PDFDocument(data: data) {
                    DispatchQueue.main.async {
                        pdfView.document = document
                    }
                } else {
                    print(" Failed to load PDF")
                }
            }
        }
    }

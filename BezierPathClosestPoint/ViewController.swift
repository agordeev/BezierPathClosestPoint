//
//  ViewController.swift
//  BezierPathClosestPoint
//
//  Created by Andrey Gordeev on 3/12/17.
//  Copyright © 2017 Andrey Gordeev (andrew8712@gmail.com). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var lineShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1.0
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        self.view.layer.addSublayer(layer)
        return layer
    }()
    private lazy var startPointShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 3.0
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        self.view.layer.addSublayer(layer)
        return layer
    }()
    private var path: BezierPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.addSublayer(startPointShapeLayer)
        addGestureRecognizer()
        drawPath()
    }

    private func addGestureRecognizer() {
        let recognzer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(recognzer)
    }

    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard ![UIGestureRecognizerState.ended, .cancelled, .failed].contains(recognizer.state) else {
            lineShapeLayer.path = nil
            startPointShapeLayer.path = nil
            return
        }
        let location = recognizer.location(in: view)
        let closestPoint = path.findClosestPointOnPath(fromPoint: location)
        drawLine(fromPoint: location, toPoint: closestPoint)
    }

    // MARK: - Drawing

    private func drawPath() {
        path = BezierPath()
        path.move(to: CGPoint(x: 10.0, y: 20.0))
        path.addCurve(to: CGPoint(x: 300.0, y: 160.0), controlPoint1: CGPoint(x: 0.0, y: 300.0), controlPoint2: CGPoint(x: 300.0, y: 300.0))
        path.addQuadCurve(to: CGPoint(x: 600.0, y: 320.0), controlPoint: CGPoint(x: 800.0, y: -50.0))

        let pathLayer = CAShapeLayer()
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.green.cgColor
        pathLayer.lineWidth = 2.0
        pathLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(pathLayer)

        path.generateLookupTable()
        for point in path.lookupTable {
            drawDot(onLayer: pathLayer, atPoint: point)
        }
    }

    private func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        let path = UIBezierPath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)

        lineShapeLayer.path = path.cgPath

        let width: CGFloat = 6.0
        let ovalPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: fromPoint.x - width * 0.5, y: fromPoint.y - width * 0.5), size: CGSize(width: width, height: width)))
        startPointShapeLayer.path = ovalPath.cgPath
    }

    @discardableResult
    private func drawDot(onLayer parentLayer: CALayer, atPoint point: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let width: CGFloat = 4.0
        let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: point.x - width * 0.5, y: point.y - width * 0.5), size: CGSize(width: width, height: width)))
        layer.path = path.cgPath
        layer.lineWidth = 1.0
        layer.strokeColor = UIColor.magenta.withAlphaComponent(0.65).cgColor
        layer.fillColor = UIColor.clear.cgColor
        parentLayer.addSublayer(layer)
        return layer
    }

}


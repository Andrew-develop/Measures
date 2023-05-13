//
//  AddPhotoViewController.swift
//  Shapely
//
//  Created by Andrew on 13.03.2023.
//

import UIKit
import SnapKit
import RxSwift

final class AddPhotoViewController: UIViewController, PropsConsumer {

    private let croppingImageView = CropView()

    private let standardImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
    }

    let canvasView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
    }

    private let backView = UIView()

    let deleteView = UIView()

    private let confirmView = ConfirmView()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var tabBar = with(UITabBar()) {
        $0.apply(.photoEdit)
        $0.items = PhotoEditItem.allCases.map { item in
            item.createButton()
        }
        $0.delegate = self
    }

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    var swiped = false

    var drawColor = UIColor.black
    var lastPoint: CGPoint!
    var linePath: [(CGPoint, CGPoint)] = []
    var linesArr: [[(CGPoint, CGPoint)]] = []
    var lineColors: [UIColor] = []

    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont: UIFont?
    var activeTextView: UITextView?
    var imageViewToPan: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        navigationItem.title = "Добавить фото"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: R.image.arrowLeft(), style: .plain, target: self, action: #selector(onBack)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: R.image.editorMagic(), style: .plain, target: self, action: #selector(onRemoveBack)
        )
        navigationItem.rightBarButtonItem?.tintColor = DefaultColorPalette.text
        navigationItem.leftBarButtonItem?.tintColor = DefaultColorPalette.text
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.view.alpha = 1.0
            self?.confirmView.animate()
            self?.confirmView.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.confirmView.prepareAfterAnimation()
        }
    }

    // to Override Control Center screen edge pan from bottom
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func prepareView() {
        backView.addSubviews(croppingImageView, standardImageView, canvasView)
        view.addSubviews(backView, tabBar, confirmView, activityIndicator)

        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBar.snp.top).offset(-Grid.s.offset)
        }
        backView.clipsToBounds = true

        croppingImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        standardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        canvasView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tabBar.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(confirmView.snp.top).offset(-Grid.s.offset)
            $0.height.equalTo(Grid.xxl.offset)
        }

        confirmView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.height.equalTo(56.0)
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.state != newProps.state {
            switch newProps.state {
            case .ready(let image):
                activityIndicator.stopAnimating()
                standardImageView.image = image
                setBaseSettings()
                view.alpha = 1
            case .loading:
                activityIndicator.startAnimating()
                setBaseSettings()
                standardImageView.isHidden = true
                canvasView.isHidden = true
                view.alpha = 0.8
            case .cropping(let image):
                croppingImageView.props = .init(image: image)
                croppingImageView.isHidden = false
                croppingImageView.isUserInteractionEnabled = true
                standardImageView.isHidden = true
                canvasView.isHidden = true
            case .drawing:
                setBaseSettings()
                remakeDrawingConstraints()
            case .filter(let image):
                standardImageView.image = image
                setBaseSettings()
            case .text:
                setBaseSettings()
                setupTextView()
            }
        }

        if let confirmProps = newProps.confirmProps {
            confirmView.props = confirmProps
        }
    }

    private func setBaseSettings() {
        croppingImageView.isHidden = true
        croppingImageView.isUserInteractionEnabled = false
        standardImageView.isHidden = false
        canvasView.isHidden = false
    }

    private func remakeDrawingConstraints() {
        guard let image = standardImageView.image else { return }

        let size = image.suitableSize(widthLimit: UIScreen.main.bounds.width)
        let emptySpace = standardImageView.frame.height
        let height = size?.height ?? emptySpace
        var realyHeight = height > emptySpace ? emptySpace : height
        realyHeight.round()

        canvasView.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(realyHeight)
        }

    }

    private func setupTextView() {
        let textView = UITextView(frame: CGRect(x: 0, y: canvasView.center.y,
                                                width: UIScreen.main.bounds.width, height: 30))

        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = drawColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.canvasView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
    }

    @objc private func onBack() {
        props.onBack.execute()
    }

    @objc private func onRemoveBack() {
        props.onRemoveBack.execute()
    }
}

extension AddPhotoViewController: CropViewControllerDelegate {
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage) {}

    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {}

    func cropViewControllerDidCancel(_ controller: CropViewController) {}
}

extension AddPhotoViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard props.state == .drawing else { return }

        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: canvasView)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard props.state == .drawing else { return }

        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: canvasView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard props.state == .drawing else { return }

        linesArr.append(linePath)
        lineColors.append(drawColor)
        linePath = []

        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
    }

    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint, color: UIColor? = nil) {
        // 1
        UIGraphicsBeginImageContext(canvasView.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            canvasView.image?.draw(in: CGRect(
                x: 0, y: 0, width: canvasView.frame.size.width, height: canvasView.frame.size.height)
            )
            // 2
            context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            // 3
            context.setLineCap(CGLineCap.round)
            context.setLineWidth(5.0)
            context.setStrokeColor(color?.cgColor ?? drawColor.cgColor)
            context.setBlendMode(CGBlendMode.normal)
            // 4
            context.strokePath()
            // 5
            canvasView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            //
            if color == nil {
                linePath.append((fromPoint, toPoint))
            }
        }
    }

    func removeLastLine(_ sender: UIButton) {
        canvasView.image = nil
        if !linesArr.isEmpty {
            linesArr.removeLast()
            lineColors.removeLast()
            drawImgFromLines()
        }
    }

    private func drawImgFromLines() {
        for (index, line) in linesArr.enumerated() {
            for path in line {
                drawLineFrom(path.0, toPoint: path.1, color: lineColors[index])
            }
        }
    }
}

extension AddPhotoViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        props.onAction.execute(with: item.tag)
    }
}

extension AddPhotoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let rotation = atan2(textView.transform.b, textView.transform.a)
        if rotation == 0 {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(
                CGSize(width: oldFrame.width, height: CGFloat.greatestFiniteMagnitude)
            )
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        lastTextViewTransform = textView.transform
        lastTextViewTransCenter = textView.center
        lastTextViewFont = textView.font!
        activeTextView = textView
        textView.superview?.bringSubviewToFront(textView)
        textView.font = UIFont(name: "Helvetica", size: 30)
        UIView.animate(withDuration: 0.3,
                       animations: {
            textView.transform = CGAffineTransform.identity
            textView.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                      y: UIScreen.main.bounds.height / 5)
        }, completion: nil)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard lastTextViewTransform != nil && lastTextViewTransCenter != nil && lastTextViewFont != nil
            else {
                return
        }
        if !containsSomeLetters(input: textView.text) {
            textView.removeFromSuperview()
            return
        }
        activeTextView = nil
        textView.font = self.lastTextViewFont!
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.transform = self.lastTextViewTransform!
                        textView.center = self.lastTextViewTransCenter!
        }, completion: nil)
    }

    func containsSomeLetters(input: String) -> Bool {
        let letters = NSCharacterSet.letters
        let range = input.rangeOfCharacter(from: letters)
        return range != nil
    }
}

extension AddPhotoViewController {
    struct Props: Mutable {
        var state: State
        var confirmProps: ConfirmView.Props?
        var onRemoveBack: Command
        var onAction: CommandWith<Int>
        var onBack: Command

        var imageHeight: CGFloat?

        enum State: Equatable {
            case loading
            case ready(UIImage)
            case drawing
            case cropping(UIImage)
            case text
            case filter(UIImage)
        }

        static var `default` = Props(
            state: .loading, confirmProps: nil, onRemoveBack: .empty,
            onAction: .empty, onBack: .empty, imageHeight: nil
        )
    }
}

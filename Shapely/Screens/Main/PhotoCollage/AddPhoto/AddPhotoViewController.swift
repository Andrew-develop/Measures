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

    private let imageView = CropView()

    private let canvasView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
    }

    private let backView = UIView()

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

    private func prepareView() {
        backView.addSubviews(imageView, canvasView)
        view.addSubviews(backView, tabBar, confirmView, activityIndicator)

        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBar.snp.top).offset(-Grid.s.offset)
        }
        backView.backgroundColor = .yellow
        backView.clipsToBounds = true

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        canvasView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(imageView.cropRect.size)
        }

        tabBar.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(confirmView.snp.top).offset(-Grid.s.offset)
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
                imageView.props = .init(image: image)
                activityIndicator.stopAnimating()
                view.alpha = 1
            case .loading:
                activityIndicator.startAnimating()
                view.alpha = 0.8
            }
        }

//        if oldProps.editItem != newProps.editItem {
//            if newProps.editItem == .crop {
//                let controller = CropViewController()
//                controller.image = imageView.image
//                controller.delegate = self
//                presentAnyway(controller, animated: true)
//            }
//        }

        if let confirmProps = newProps.confirmProps {
            confirmView.props = confirmProps
        }
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
        guard props.editItem == .draw else { return }

        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: canvasView)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard props.editItem == .draw else { return }

        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: canvasView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard props.editItem == .draw else { return }

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

extension AddPhotoViewController {
    struct Props: Mutable {
        var state: State
        var editItem: PhotoEditItem?
        var confirmProps: ConfirmView.Props?
        var onRemoveBack: Command
        var onAction: CommandWith<Int>
        var onBack: Command

        var imageHeight: CGFloat?
        var isDrawing: Bool

        enum State: Equatable {
            case loading
            case ready(UIImage)
        }

        static var `default` = Props(
            state: .loading, editItem: nil, confirmProps: nil, onRemoveBack: .empty,
            onAction: .empty, onBack: .empty, imageHeight: nil, isDrawing: false
        )
    }
}

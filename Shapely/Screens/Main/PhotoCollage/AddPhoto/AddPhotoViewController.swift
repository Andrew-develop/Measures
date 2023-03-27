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

    private let imageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
    }

    private let confirmView = ConfirmView()

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(recognizer)

        prepareView()
    }

    private func runAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.apply(.primary)
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let cancel = UIAlertAction(title: R.string.localizable.buttonCancel(), style: .cancel)
        let library = UIAlertAction(title: "Галерея", style: .default) { [weak self] _ in
            imagePickerController.sourceType = .photoLibrary
            self?.present(imagePickerController, animated: true)
        }
        let camera = UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
            imagePickerController.sourceType = .camera
            self?.present(imagePickerController, animated: true)
        }
        alertController.addAction(camera)
        alertController.addAction(library)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }

    private func prepareView() {
        view.addSubviews(imageView, confirmView)

        makeConstraints()
    }

    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalTo(confirmView.snp.top).offset(-Grid.s.offset)
        }

        confirmView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.height.equalTo(56.0)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.image != newProps.image {
            imageView.image = newProps.image
        }

        if let confirmProps = newProps.confirmProps {
            confirmView.props = confirmProps
        }

        if oldProps.isNeedShowPicker != newProps.isNeedShowPicker && newProps.isNeedShowPicker {
            runAlert()
        }
    }

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as? UIImage
        props.onSelectImage.execute(with: image)

        picker.dismiss(animated: true)
    }
}

extension AddPhotoViewController {
    struct Props: Mutable {
        var image: UIImage?
        var confirmProps: ConfirmView.Props?
        var isNeedShowPicker: Bool
        var onTap: Command
        var onSelectImage: CommandWith<UIImage?>

        static var `default` = Props(image: nil, confirmProps: nil, isNeedShowPicker: false,
                                     onTap: .empty, onSelectImage: .empty)
    }
}

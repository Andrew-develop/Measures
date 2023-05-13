//
//  PhotoCollageViewController.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit
import SnapKit
import RxSwift

final class PhotoCollageViewController: UIViewController, PropsConsumer {
    private let tableAdapter: PhotoCollageTableAdapter
    private let daysTableAdapter: PhotoCollageDaysTableAdapter

    private lazy var tableView = with(UITableView()) {
        $0.apply(.primary)
        $0.register(InitialStartTitleCell.self, forCellReuseIdentifier: InitialStartTitleCell.className)
        $0.register(PhotoTypesCell.self, forCellReuseIdentifier: PhotoTypesCell.className)
        $0.register(AddWidgetCell.self, forCellReuseIdentifier: AddWidgetCell.className)
        $0.register(DayPhotosCell.self, forCellReuseIdentifier: DayPhotosCell.className)
    }

    private lazy var daysTableView = with(UITableView()) {
        $0.apply(.primary)
        $0.register(InitialStartTitleCell.self, forCellReuseIdentifier: InitialStartTitleCell.className)
        $0.register(DayPhotosCell.self, forCellReuseIdentifier: DayPhotosCell.className)
    }

    private let titleLabel = with(UILabel()) {
        $0.apply(.screenTitle)
    }

    private let controlButton = with(UIButton()) {
        $0.apply(.controlButton)
    }

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: PhotoCollageTableAdapter,
         daysTableAdapter: PhotoCollageDaysTableAdapter) {
        self.tableAdapter = tableAdapter
        self.daysTableAdapter = daysTableAdapter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        daysTableAdapter.makeDiffableDataSource(daysTableView)
        tableAdapter.makeDiffableDataSource(tableView)
    }

    private func prepareView() {
        view.apply(.backgroundColor)
        view.addSubviews(titleLabel, controlButton, tableView, daysTableView)

        controlButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)

        makeConstraints()
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(Grid.s.offset)
            $0.trailing.equalTo(controlButton.snp.leading).offset(-Grid.xs.offset)
        }

        controlButton.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-Grid.s.offset)
            $0.size.equalTo(CGSize(width: Grid.sm.offset, height: Grid.sm.offset))
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Grid.s.offset)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalToSuperview()
        }

        daysTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Grid.s.offset)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.byDays != newProps.byDays, let byDays = newProps.byDays {
            if byDays {
                daysTableAdapter.category = newProps.days
                tableView.isHidden = true
                daysTableView.isHidden = false
            } else {
                tableAdapter.category = newProps.category
                tableView.isHidden = false
                daysTableView.isHidden = true
            }
        }

        if oldProps.title != newProps.title {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.03
            titleLabel.attributedText = NSMutableAttributedString(
                string: newProps.title,
                attributes: [
                    NSAttributedString.Key.kern: -0.41,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
            )
        }

        if oldProps.isNeedShowPicker != newProps.isNeedShowPicker && newProps.isNeedShowPicker {
            runAlert()
        }
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

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension PhotoCollageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as? UIImage

        picker.dismiss(animated: true) { [weak self] in
            self?.props.onSelectImage.execute(with: image)
        }
    }
}

extension PhotoCollageViewController {
    struct Props: Mutable {
        var title: String
        var byDays: Bool?
        var category: [Angel: [AnyHashable]]
        var days: [AnyHashable]
        var isNeedShowPicker: Bool
        var onTap: Command
        var onSelectImage: CommandWith<UIImage?>

        static var `default` = Props(title: "", byDays: nil, category: [:], days: [], isNeedShowPicker: false,
                                     onTap: .empty, onSelectImage: .empty)
    }
}

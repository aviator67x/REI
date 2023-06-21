//import AVFoundation
//import UIKit
//
//enum PhotoState {
//    case photo
//    case settings
//}
//
//final class PhotoViewController: UIViewController {
//    // MARK: - Internal properties
//
//    // MARK: - Private properties
//    private var screenState: PhotoState = .settings
//    private var captureSession: AVCaptureSession!
//    private var backCamera: AVCaptureDevice!
//    private var frontCamera: AVCaptureDevice!
//    private var backInput: AVCaptureInput!
//    private var frontInput: AVCaptureInput!
//    private var previewLayer: AVCaptureVideoPreviewLayer!
//    private var videoOutput: AVCaptureVideoDataOutput!
//    private var takePicture = false
//    private var backCameraOn = true
//
//    // MARK: - View Components.
//    private lazy var switchCameraButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .yellow
//        button.setImage(Assets.switchCamera.image, for: .normal)
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(switchCamera(_:)), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var captureImageButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .white
//        let image = UIImage(named: "circleButton")
//        button.setImage(Assets.circleButton.image, for: .normal)
//        button.isEnabled = true
//        button.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var cameraView = UIView()
//
//    private lazy var capturedImageView = CapturedImageView()
//
//    private lazy var nextButton: BaseButton = {
//        let button = BaseButton(buttonState: .next)
//        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var takePhotoLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Take photos with Interngram"
//        label.font = UIFont.systemFont(ofSize: 22)
//        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//
//    private lazy var allowAccessLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "Allow access to you camera to start taking photos with the Interngram app"
//        label.font = UIFont.systemFont(ofSize: 15)
//        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private lazy var allowSettingsTextView: UITextView = {
//        let textView = UITextView()
//        textView.isEditable = false
//        textView.isScrollEnabled = false
//        textView.delegate = self
//        let string = "Allow in Settings"
//        let attributedString = NSMutableAttributedString(string: string)
//        let nsString = string as NSString
//        let range = nsString.range(of: string)
//        attributedString.addAttribute(
//            .link,
//            value: URL(string: UIApplication.openSettingsURLString),
//            range: range
//        )
//        textView.attributedText = attributedString
//        textView.font = UIFont.systemFont(ofSize: 15)
//        textView.textAlignment = .center
//        return textView
//    }()
//
//    // MARK: - Life Cycle
//
//    init(screenState: PhotoState) {
//        self.screenState = screenState
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupNavigationBar()
//
//        switch screenState {
//        case .settings: setupSettingsView()
//        case .photo: setupPhotoView()
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        switchCameraButton.layer.cornerRadius = switchCameraButton.frame.height * 0.5
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        capturedImageView.isHidden = true
//        nextButton.isHidden = true
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
////        checkPermissions()
//        if screenState == .photo {
//            setupAndStartCaptureSession()
//        }
//    }
//
//    // MARK: - Actions
//
//    @objc
//    func captureImage(_ sender: UIButton?) {
//        takePicture = true
//    }
//
//    @objc
//    func switchCamera(_ sender: UIButton?) {
//        switchCameraInput()
//    }
//
//    @objc
//    func nextButtonDidTap() {
////        presenter.addPhotoToAvatarView(imageToCrop: capturedImageView.imageMain, cropRect: returnCropRect())
//    }
//
//    @objc
//    func cancelDidTapped() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    // MARK: - Camera Setup
//
//    private func setupNavigationBar() {
//        let cancelButton = UIBarButtonItem(
//            title: "Cancel",
//            style: .plain,
//            target: self,
//            action: #selector(cancelDidTapped)
//        )
//        cancelButton.setTitleTextAttributes(
//            [
//                NSAttributedString.Key.font: FontFamily.SFProText.regular.font(size: 15),
//                NSAttributedString.Key.foregroundColor: UIColor.black,
//            ],
//            for: .normal
//        )
//        navigationItem.leftBarButtonItem = cancelButton
//
//        title = "Photo"
//    }
//
//    private func setupAndStartCaptureSession() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.captureSession = AVCaptureSession()
//            self.captureSession.beginConfiguration()
//            if self.captureSession.canSetSessionPreset(.photo) {
//                self.captureSession.sessionPreset = .photo
//            }
//            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
//
//            self.setupInputs()
//
//            DispatchQueue.main.async {
//                self.setupPreviewLayer()
//            }
//
//            self.setupOutput()
//
//            self.captureSession.commitConfiguration()
//
//            self.captureSession.startRunning()
//        }
//    }
//
//    private func setupPreviewLayer() {
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame.size = cameraView.frame.size
//        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//
//        previewLayer.connection?.videoOrientation = .portrait
//        cameraView.layer.addSublayer(previewLayer)
//    }
//
//    private func setupOutput() {
//        videoOutput = AVCaptureVideoDataOutput()
//        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
//        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
//
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//        } else {
//            fatalError("could not add video output")
//        }
//
//        videoOutput.connections.first?.videoOrientation = .portrait
//    }
//
//    private func setupInputs() {
//        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
//            backCamera = device
//        } else {
//            fatalError("no back camera")
//        }
//
//        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
//            frontCamera = device
//        } else {
//            fatalError("no front camera")
//        }
//
//        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
//            fatalError("could not create input device from back camera")
//        }
//        backInput = bInput
//        if !captureSession.canAddInput(backInput) {
//            fatalError("could not add back camera input to capture session")
//        }
//
//        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
//            fatalError("could not create input device from front camera")
//        }
//        frontInput = fInput
//        if !captureSession.canAddInput(frontInput) {
//            fatalError("could not add front camera input to capture session")
//        }
//
//        captureSession.addInput(backInput)
//    }
//
//    private func switchCameraInput() {
//        switchCameraButton.isUserInteractionEnabled = false
//
//        captureSession.beginConfiguration()
//        if backCameraOn {
//            captureSession.removeInput(backInput)
//            captureSession.addInput(frontInput)
//            backCameraOn = false
//        } else {
//            captureSession.removeInput(frontInput)
//            captureSession.addInput(backInput)
//            backCameraOn = true
//        }
//
//        videoOutput.connections.first?.videoOrientation = .portrait
//
//        videoOutput.connections.first?.isVideoMirrored = !backCameraOn
//
//        captureSession.commitConfiguration()
//
//        switchCameraButton.isUserInteractionEnabled = true
//    }
//
//    func returnCropRect() -> CGRect {
//        let cropRect = capturedImageView.cropView.convert(
//            capturedImageView.cropView.bounds,
//            to: capturedImageView.imageMain
//        )
//        return cropRect
//    }
//
//    private func setupPhotoView() {
//        cameraView.layer.fillMode = .forwards
//        cameraView.contentMode = .scaleAspectFit
//
//        view.addSubview(cameraView) {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            $0.left.right.equalToSuperview()
//            $0.height.equalTo(view.frame.width)
//        }
//
//        view.addSubview(capturedImageView) {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            $0.left.right.equalToSuperview()
//            $0.height.equalTo(view.frame.width)
//        }
//
//        view.addSubview(switchCameraButton) {
//            $0.right.equalToSuperview().inset(16)
//            $0.bottom.equalTo(cameraView.snp.bottom).inset(16)
//            $0.size.equalTo(45)
//        }
//
//        view.addSubview(nextButton) {
//            $0.top.equalTo(capturedImageView.snp.bottom).offset(45)
//            $0.leading.equalToSuperview().offset(16)
//            $0.trailing.equalToSuperview().offset(-16)
//            $0.height.equalTo(44)
//        }
//
//        view.addSubview(captureImageButton) {
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(view.frame.height * 0.2)
//            $0.centerX.equalToSuperview()
//            $0.size.equalTo(75)
//        }
//
//        view.bringSubviewToFront(switchCameraButton)
//    }
//
//    private func setupSettingsView() {
//        view.addSubview(takePhotoLabel) {
//            $0.top.equalTo(view.bounds.height * 0.4)
//            $0.left.right.equalToSuperview().inset(46)
//            $0.height.equalTo(28)
//        }
//
//        view.addSubview(allowAccessLabel) {
//            $0.top.equalTo(takePhotoLabel.snp.bottom).offset(32)
//            $0.left.right.equalToSuperview().inset(46)
//            $0.height.equalTo(40)
//        }
//
//        view.addSubview(allowSettingsTextView) {
//            $0.top.equalTo(allowAccessLabel.snp.bottom).offset(32)
//            $0.left.right.equalToSuperview().inset(46)
//            $0.height.equalTo(40)
//        }
//    }
//
//    // MARK: - Permissions
//
//    private func checkPermissions() {
//        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
//        switch cameraAuthStatus {
//        case .authorized:
//            return
//        case .denied:
//            abort()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { authorized in
//                if !authorized {
//                    abort()
//                }
//            })
//        case .restricted:
//            abort()
//        @unknown default:
//            fatalError()
//        }
//    }
//}
//
//// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
//
//extension PhotoViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(
//        _ output: AVCaptureOutput,
//        didOutput sampleBuffer: CMSampleBuffer,
//        from connection: AVCaptureConnection
//    ) {
//        if !takePicture {
//            return
//        }
//
//        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//
//        let ciImage = CIImage(cvImageBuffer: cvBuffer)
//
//        let uiImage = UIImage(ciImage: ciImage)
//
//        DispatchQueue.main.async {
//            self.capturedImageView.image = uiImage
//            self.capturedImageView.isHidden = false
//            self.nextButton.isHidden = false
//            self.captureImageButton.isHidden = true
//            self.captureSession.stopRunning()
//            self.takePicture = false
//        }
//    }
//}
//
//// MARK: - UITextViewDelegate
//
//extension PhotoViewController: UITextViewDelegate {
//    func textView(
//        _ textView: UITextView,
//        shouldInteractWith URL: URL,
//        in characterRange: NSRange,
//        interaction: UITextItemInteraction
//    ) -> Bool {
//      
//        return false
//    }
//}

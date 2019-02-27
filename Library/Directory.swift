class Directory: Document {
    override var editable: Bool { return false }
    override var ruler: Bool { return false }
    override var content: String { return name + "/" }
}

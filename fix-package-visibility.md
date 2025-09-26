# Fix Package Visibility

The error "denied" means the package is private. To fix:

## Make Package Public

1. Go to: https://github.com/nghyane?tab=packages
2. Click on "truyenqq-clone" package
3. Click "Package settings" (gear icon)
4. Scroll to "Danger Zone"
5. Click "Change visibility"
6. Select "Public"
7. Confirm

## Alternative: Keep Private

If you want to keep it private, users need to authenticate with a token that has `read:packages` permission.

The install script already handles this with GitHub CLI authentication.
# Contributing to Developer Optimizer

First off, thank you for considering contributing to the Developer Optimizer! It's people like you that make this tool so great. 🙏

## Code of Conduct

This project adheres to principles of respect, inclusivity, and constructive collaboration. When contributing, please be respectful and considerate of others.

---

## How Can I Contribute?

### 🐛 Report a Bug

Found something that's broken? Here's how to report it:

1. **Check existing issues** - Does it already exist?
2. **Create a new issue** with:
   - Clear, descriptive title
   - What you were trying to do
   - What happened instead
   - Your system specs:
     ```
     Windows version: (10/11)
     Build number: (22H2, etc.)
     CPU: (i7/i9)
     RAM: (16GB, etc.)
     GPU: (RTX model)
     ```
   - Error messages or output
   - Steps to reproduce

### 💡 Suggest an Enhancement

Have an idea to improve the optimizer?

1. **Check existing discussions** - Has it been suggested?
2. **Open a discussion/issue** with:
   - Clear title describing the enhancement
   - Detailed description of the feature
   - Why you think it would be useful
   - Any example implementations or references

### 📝 Improve Documentation

Documentation improvements are always welcome:

1. Found a typo? Fix it!
2. Unclear instructions? Clarify them!
3. Missing troubleshooting steps? Add them!
4. Example not working? Update it!

Just edit the markdown files and submit a PR.

### 💻 Write Code

Want to contribute code? Great!

**Before you start:**
1. Check existing issues/PRs for related work
2. Comment on the issue you're tackling
3. Follow the coding style guide
4. Test thoroughly
5. Update documentation

**Coding Standards:**
- PowerShell Style Guide: [PoshCode Style Guide](https://poshcode.org/style-guide)
- Use descriptive variable names
- Comment complex logic
- Handle errors gracefully
- Validate inputs before use
- Write helper functions for reusable code

**Example PR:**
```powershell
# Good: Clear function with comments
function Stop-ProcessSafely {
    param([string]$ProcessName, [string]$Description = "")
    
    # Get processes safely
    $procs = @(Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)
    if ($procs.Count -gt 0) {
        # Stop processes and report
        $procs | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Host "  ✓ $ProcessName ($($procs.Count) process(es)) - $Description" -ForegroundColor Green
        return $true
    }
    return $false
}
```

---

## Getting Started

### Setup Development Environment

1. **Clone the repository:**
   ```powershell
   git clone https://github.com/Safacts/Optimizer.git
   cd Optimizer
   ```

2. **Create a development branch:**
   ```powershell
   git checkout -b feature/your-feature-name
   ```

3. **Test your changes:**
   ```powershell
   # Preview changes without applying
   .\DeveloperPerfOptimizer.ps1 -DryRun
   
   # Test the actual optimization
   .\DeveloperPerfOptimizer.ps1
   ```

4. **Test the undo script:**
   ```powershell
   .\DeveloperPerfOptimizer-Undo.ps1
   ```

### Pull Request Process

1. **Update documentation:**
   - Update README.md if needed
   - Update OPTIMIZER_GUIDE.md for behavior changes
   - Update CHANGELOG.md with your changes

2. **Test thoroughly:**
   - Run with `-DryRun` flag
   - Test actual execution
   - Test undo script
   - Verify all error cases

3. **Commit messages:**
   ```
   [type] Concise description (50 chars max)
   
   More detailed explanation if needed.
   - Include relevant issue numbers
   - Explain 'why' not just 'what'
   - Reference any related changes
   ```
   
   Types:
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation only
   - `refactor:` Code refactoring
   - `perf:` Performance improvement
   - `test:` Test additions

   Example:
   ```
   feat: Add temperature monitoring integration
   
   - Detects HWiNFO installation
   - Reads GPU temp via registry
   - Warns if temp exceeds threshold
   - Logs to file for diagnostics
   
   Fixes #123
   ```

4. **Create a Pull Request:**
   - Clear title describing the change
   - Link to related issues
   - Describe what changed and why
   - List testing performed
   - Note any breaking changes

---

## Development Guidelines

### Code Quality
- Keep functions small and focused (single responsibility)
- Use descriptive variable names
- Comment non-obvious logic
- Handle errors explicitly
- Validate all inputs
- Test edge cases

### Testing
- Test with `-DryRun` first
- Test actual execution on clean system
- Test undo/revert process
- Test on Windows 10 and 11
- Test with various hardware configs
- Document test results in PR

### Documentation
- Update comments if code changes
- Update guides if behavior changes
- Add examples for new features
- Maintain changelog entries
- Keep README current
- Document edge cases

### PowerShell Best Practices
```powershell
# ✅ Good - Descriptive, clear
$processesToKill = @("Discord", "Steam", "OneDrive")
foreach ($process in $processesToKill) {
    Get-Process -Name $process -ErrorAction SilentlyContinue | 
        Stop-Process -Force -ErrorAction SilentlyContinue
}

# ❌ Bad - Unclear, hard to test
$x=@("Discord","Steam","OneDrive");$x|%{gps $_ -ea 0|Stop-Process -f -ea 0}
```

---

## Commit Message Guidelines

### Format:
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types:
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation change
- `style` - Code style (formatting, missing semicolons, etc.)
- `refactor` - Code refactoring without feature change
- `perf` - Performance improvement
- `test` - Adding/updating tests
- `chore` - Maintenance tasks

### Examples:

**Good:**
```
feat(gpu): Add RTX 3080 Ti detection

- Detect RTX 3080 Ti in GPU discovery
- Add to acceleration targets
- Test GPU preference registry key

Fixes #45
```

**Good:**
```
fix(defender): Disable fails on Windows 10 Home

- Check Windows edition before disabling Defender
- Fall back gracefully on unsupported editions
- Log warning for user awareness

Closes #67
```

**Avoid:**
```
fix stuff
updated code
bug fix
```

---

## Reporting Security Issues

⚠️ **Do NOT create a public issue for security vulnerabilities.**

Instead, email security details to the maintainer with:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)

---

## Code Review Process

1. **Automated checks:**
   - PowerShell syntax validation
   - Basic script execution test
   - Documentation completeness

2. **Manual review:**
   - Code quality assessment
   - Logic verification
   - Security implications
   - Performance impact
   - Documentation updates

3. **Approval:**
   - At least one maintainer approval required
   - All feedback addressed
   - Tests passing

4. **Merge:**
   - Squash commits for clarity
   - Delete feature branch
   - Close related issues

---

## Testing Checklist

Before submitting improvements:

- [ ] Code follows PowerShell best practices
- [ ] Functions have descriptive names
- [ ] Error handling is comprehensive
- [ ] Comments explain complex logic
- [ ] Script runs without syntax errors
- [ ] `-DryRun` mode works correctly
- [ ] Actual execution works as expected
- [ ] Undo script reverses changes
- [ ] Documentation is updated
- [ ] Changelog entry is added
- [ ] No breaking changes introduced
- [ ] Tested on Windows 10 and 11
- [ ] Tested with various hardware

---

## Recognition

Contributors will be recognized in:
- README.md in a contributors section
- Release notes for their version
- GitHub contributors graph

---

## Questions?

- 💬 GitHub Discussions for general questions
- 🐞 GitHub Issues for bugs
- 📧 Email maintainer for sensitive topics

---

## License

By contributing, you agree that your contributions will be licensed under the same MIT License as the project.

---

**Thank you for making the Developer Optimizer better! 🚀**

Last Updated: March 31, 2026

# GitHub Instructions Guide

This guide covers the most common Git and GitHub commands you will need for your project.

## 1. First Time Push (Pushing a New Repository)
If you have a brand new project and want to push it to GitHub for the very first time, run these commands in your project directory:

```bash
# Initialize the local directory as a Git repository
git init

# Add all files in the directory to staging
git add .

# Commit the files that you've staged
git commit -m "first commit"

# Rename the default branch to 'main'
git branch -M main

# Add the URL for the remote repository where your local repository will be pushed
git remote add origin <your_repository_URL>

# Push the changes in your local repository up to the remote repository
git push -u origin main
```
*(Note: You only need to do this once per new project!)*

---

## 2. Pushing Updates (When you modify or add files)
When you make changes to your code, create new files, or delete files, use this process to push those updates to GitHub:

```bash
# 1. Check which files have been modified (Optional but recommended)
git status

# 2. Add all changed files to staging
git add .
# (Or to add a specific file: git add filename.txt)

# 3. Commit your changes with a descriptive message
git commit -m "Add a descriptive message about what you changed"

# 4. Push the changes to GitHub
git push
```

---

## 3. Pulling Updates (When code changes on GitHub)
If you or someone else makes a change directly on GitHub or from another computer, you need to pull those changes down to your local machine before you start working:

```bash
# Fetch and merge changes from the remote repository to your local machine
git pull
```

---

## 4. Working with Branches
Branches allow you to experiment with new features without breaking your main project.

```bash
# Create a new branch and switch to it
git checkout -b <branch_name>
# Example: git checkout -b feature-dark-mode

# List all branches to see which one you are currently on
git branch

# Switch back to the main branch
git checkout main

# Merge the changes from your feature branch into the main branch
# (Make sure you are on the main branch before running this)
git merge <branch_name>
```

---

## 5. Other Useful Commands

**View Commit History**
See a log of all the commits made to the repository:
```bash
git log
```

**Undo Uncommitted Changes**
If you made changes to a file but want to revert it back to how it was in the last commit:
```bash
# Undo changes in a specific file
git checkout -- filename.txt

# Undo all uncommitted changes in the project
git checkout .
```

**Remove a File from Git Tracking (but keep it on your computer)**
```bash
git rm --cached filename.txt
```

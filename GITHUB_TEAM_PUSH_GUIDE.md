# KUET Trade - One Laptop, 3 GitHub Accounts, 1 Repo

This guide explains how your 3-member team can push to one GitHub repository from a single Windows laptop.

Repo: https://github.com/Torikul-048/KUET_Trade

Members:

- Torikul: https://github.com/Torikul-048
- Farid: https://github.com/Farid-43
- Sayeem: https://github.com/Sayeem33

## 1) Short Answer

Yes, this is possible.

You can use one laptop and still have commits attributed to different members.

Important:

- Commit author identity comes from git user.name and user.email at commit time.
- Push permission comes from the GitHub account currently authenticated on that push.
- Repo owner stays the same (Torikul-048), but collaborators can push if invited and accepted.

## 2) Collaborator Setup (Do This First)

Owner account must add collaborators:

1. Open repo settings on GitHub.
2. Go to Collaborators.
3. Invite Farid-43 and Sayeem33.
4. Both must accept invitation.

Without accepted invite, they cannot push.

## 3) Initialize Local Git (Current Status: Not Initialized)

Run from project root where README.md exists:

1. cd /d e:\3-2\MC\KUET_Trade\KUET_Trade
2. git init
3. git branch -M main
4. git remote add origin https://github.com/Torikul-048/KUET_Trade.git

## 4) Recommended Team Workflow

Use separate branches by ownership, then merge to main.

Suggested ownership mapping:

Member 1 (Auth + Onboarding):

- KUET_Trade/ContentView.swift
- KUET_Trade/ViewModels/AuthViewModel.swift
- KUET_Trade/Views/Auth/\*
- KUET_Trade/KUET_TradeApp.swift

Member 2 (Marketplace + Search):

- KUET_Trade/ViewModels/ItemViewModel.swift
- KUET_Trade/Views/Home/\*
- KUET_Trade/Views/Search/\*
- KUET_Trade/Views/Components/ContactSellerButton.swift

Member 3 (Seller tools + Profile):

- KUET_Trade/ViewModels/PostItemViewModel.swift
- KUET_Trade/Views/Post/\*
- KUET_Trade/Views/Profile/\*
- KUET_Trade/Views/MainTabView.swift

## 5) How To Push From One Laptop As Different Members

For each member session:

Current confirmed identities:

- Farid: user.name = Farid Ahmed, user.email = 130706495+FaridCS@users.noreply.github.com
- Sayeem: user.name = Sayeem33, user.email = sayeem192058@gmail.com
- Torikul: user.name = Torikul-048, user.email = islam2107048@stud.kuet.ac.bd

1. Set commit identity (pick the exact member before committing):

- For Farid:
  - git config user.name "Farid Ahmed"
  - git config user.email "130706495+FaridCS@users.noreply.github.com"

- For Sayeem:
  - git config user.name "Sayeem33"
  - git config user.email "sayeem192058@gmail.com"

- For Torikul:
  - git config user.name "Torikul-048"
  - git config user.email "islam2107048@stud.kuet.ac.bd"

- Verify before commit:
  - git config --get user.name
  - git config --get user.email

2. Create/switch branch:

- git checkout -b feature/memberX-topic

3. Stage and commit:

- git add .
- git commit -m "Meaningful commit message"

4. Ensure correct GitHub login before push:

- If needed, remove old github.com credential from Windows Credential Manager.
- Then push and sign in with the intended member account.

5. Push:

- git push -u origin feature/memberX-topic

Then open Pull Request and merge to main.

## 6) Your Question: "If I only change GitHub login, does it still push to one ID?"

Clarification:

- All pushes go to the same repository URL (Torikul-048/KUET_Trade).
- The account used during push must have permission.
- Commit author shown on GitHub depends on commit email, not repo owner.

So yes, same repo always, but authorship and "pushed by" can differ.

## 7) Commit Date Planning (March Timeline)

Technically, Git supports custom commit dates.

Use only if this reflects real work timeline and your course rules allow it.

Windows CMD example for one commit date:

- set GIT_AUTHOR_DATE=2026-03-02T10:20:00+0600 && set GIT_COMMITTER_DATE=2026-03-02T10:20:00+0600 && git commit -m "Auth: add login validation"

Suggested split (15-20 commits):

- Week 1 (around March 1 to March 7): around half (8-10 commits)
- After March 26 week: remaining half (7-10 commits)

Keep commits real and scoped (not random).

## 8) Practical Sequence For Your Team

1. Initialize git and connect remote.
2. Add collaborators and confirm accepted invites.
3. Create 3 feature branches (one per member).
4. Commit module-wise with correct name/email per member.
5. Push each branch with corresponding member account login.
6. Merge PRs to main in order.
7. Final cleanup: tag release v1.0.

## 9) If You Want Full Attribution Without Account Switching

Alternative:

- One person can push, but use Co-authored-by trailers in commit messages.
- This may show contribution on co-authors' profiles if emails are correct and verified.

Example trailer lines:

- Co-authored-by: Farid <farid_email@example.com>
- Co-authored-by: Sayeem <sayeem_email@example.com>

## 10) Final Notes

- You do not need macOS to push code. Windows Git is enough.
- You only need macOS/Xcode to build/run iOS app.
- Keep commit messages clean and module-based for defense/demo.

//
//  ConversationsListView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI
import UIKit

struct ConversationsListView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var searchText = ""
    @State private var selectedFilter: ConversationFilter = .all
    @State private var isToastVisible = false
    @State private var toastMessage = ""
    @State private var toastSubtitle: String?
    @State private var toastSystemImage = "checkmark.circle.fill"
    @State private var toastHint: String?
    @State private var toastDismissTask: Task<Void, Never>?
    @State private var pendingUndoAction: UndoAction?
    @State private var pendingBulkAction: PendingBulkAction?
    @State private var editMode: EditMode = .inactive
    @State private var lastDestructiveActionAt: Date = .distantPast
    @AppStorage("prioritizeUnreadPinned") private var prioritizeUnreadPinned = false
    @AppStorage("mutedConversationIDs") private var mutedConversationIDsRaw = ""
    @AppStorage("pinnedConversationIDs") private var pinnedConversationIDsRaw = ""
    @AppStorage("pinnedConversationOrder") private var pinnedConversationOrderRaw = ""

    private var currentUser: KTUser? {
        AuthViewModel.shared.currentUser
    }

    private var filteredConversations: [Conversation] {
        guard let currentUserId = currentUser?.uid else {
            return viewModel.conversations
        }

        var conversations = viewModel.conversations

        switch selectedFilter {
        case .all:
            break
        case .unread:
            conversations = conversations.filter { $0.unread(for: currentUserId) > 0 }
        case .muted:
            conversations = conversations.filter {
                guard let conversationId = $0.id else { return false }
                return mutedConversationIDs.contains(conversationId)
            }
        }

        let query = searchText.trimmed.lowercased()
        guard !query.isEmpty else {
            return conversations
        }

        return conversations.filter { conversation in
            let name = conversation.displayName(for: currentUserId).lowercased()
            let itemTitle = (conversation.itemTitle ?? "").lowercased()
            let lastMessage = conversation.lastMessage.lowercased()

            return name.contains(query) || itemTitle.contains(query) || lastMessage.contains(query)
        }
    }

    private var pinnedConversations: [Conversation] {
        let pinOrderLookup = Dictionary(uniqueKeysWithValues: pinnedConversationOrder.enumerated().map { ($1, $0) })
        let currentUserId = currentUser?.uid

        return filteredConversations.filter {
            guard let conversationId = $0.id else { return false }
            return pinnedConversationIDs.contains(conversationId)
        }
        .sorted { lhs, rhs in
            if prioritizeUnreadPinned, let currentUserId {
                let lhsHasUnread = lhs.unread(for: currentUserId) > 0
                let rhsHasUnread = rhs.unread(for: currentUserId) > 0
                if lhsHasUnread != rhsHasUnread {
                    return lhsHasUnread && !rhsHasUnread
                }
            }

            guard let lhsID = lhs.id, let rhsID = rhs.id else {
                return lhs.lastMessageTime > rhs.lastMessageTime
            }

            let lhsRank = pinOrderLookup[lhsID] ?? Int.max
            let rhsRank = pinOrderLookup[rhsID] ?? Int.max
            if lhsRank != rhsRank {
                return lhsRank < rhsRank
            }

            return lhs.lastMessageTime > rhs.lastMessageTime
        }
    }

    private var unpinnedConversations: [Conversation] {
        filteredConversations.filter {
            guard let conversationId = $0.id else { return true }
            return !pinnedConversationIDs.contains(conversationId)
        }
        .sorted { $0.lastMessageTime > $1.lastMessageTime }
    }

    private var canReorderPinned: Bool {
        searchText.trimmed.isEmpty && selectedFilter == .all && pinnedConversations.count > 1
    }

    private var visibleUnreadConversationIDs: [String] {
        guard let currentUserId = currentUser?.uid else { return [] }

        return filteredConversations.compactMap { conversation in
            guard
                let conversationId = conversation.id,
                conversation.unread(for: currentUserId) > 0
            else {
                return nil
            }

            return conversationId
        }
    }

    private var visibleConversationIDs: [String] {
        filteredConversations.compactMap(\.id)
    }

    private var visibleUnmutedConversationIDs: [String] {
        visibleConversationIDs.filter { !mutedConversationIDs.contains($0) }
    }

    private var visibleMutedConversationIDs: [String] {
        visibleConversationIDs.filter { mutedConversationIDs.contains($0) }
    }

    private var hasBulkActions: Bool {
        !visibleUnreadConversationIDs.isEmpty ||
        !visibleUnmutedConversationIDs.isEmpty ||
        !visibleMutedConversationIDs.isEmpty ||
        !mutedConversationIDs.isEmpty ||
        !pinnedConversationIDs.isEmpty
    }

    private var summaryPinnedCount: Int {
        pinnedConversationIDs.count
    }

    private var summaryMutedCount: Int {
        mutedConversationIDs.count
    }

    private var summaryUnreadCount: Int {
        guard let currentUserId = currentUser?.uid else { return 0 }
        return viewModel.conversations.reduce(0) { partial, conversation in
            partial + conversation.unread(for: currentUserId)
        }
    }

    private var toastAccessibilityText: String {
        [toastMessage, toastSubtitle, toastHint]
            .compactMap { $0 }
            .joined(separator: ". ")
    }

    private var destructiveActionCooldown: TimeInterval {
        0.55
    }

    var body: some View {
        NavigationStack {
            List {
                // Filter chips always visible so you can switch filters freely
                if !viewModel.isLoading {
                    filterChipsRow
                        .listRowSeparator(.hidden)
                }

                if viewModel.isLoading {
                    ProgressView("Loading chats...")
                } else if viewModel.conversations.isEmpty {
                    ContentUnavailableView(
                        "No Conversations",
                        systemImage: "bubble.left.and.bubble.right",
                        description: Text("Open an item and tap Message Seller to start.")
                    )
                } else if filteredConversations.isEmpty {
                    ContentUnavailableView(
                        "No Matching Conversations",
                        systemImage: "line.3.horizontal.decrease.circle",
                        description: Text("Try a different filter or search text.")
                    )
                } else {
                    if let currentUserId = currentUser?.uid {
                        if !pinnedConversations.isEmpty {
                            Section("Pinned") {
                                ForEach(pinnedConversations) { conversation in
                                    conversationRow(conversation, currentUserId: currentUserId)
                                }
                                .onMove(perform: movePinnedConversations)
                            }
                        }

                        ForEach(unpinnedConversations) { conversation in
                            conversationRow(conversation, currentUserId: currentUserId)
                        }
                    }
                }
            }
            .navigationTitle("Messages")
            .toolbar {
                if hasBulkActions {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu("Actions") {
                            if !visibleUnreadConversationIDs.isEmpty {
                                Button("Mark All Read") {
                                    requestBulkMarkAllRead()
                                }
                                .accessibilityHint("Marks all visible unread conversations as read")
                            }

                            if !visibleUnmutedConversationIDs.isEmpty {
                                Button("Mute Visible") {
                                    requestBulkMuteVisible()
                                }
                                .accessibilityHint("Mutes notifications for visible conversations")
                            }

                            if !visibleMutedConversationIDs.isEmpty {
                                Button("Unmute Visible") {
                                    requestBulkUnmuteVisible()
                                }
                                .accessibilityHint("Unmutes notifications for visible conversations")
                            }

                            if !mutedConversationIDs.isEmpty {
                                Button(role: .destructive) {
                                    requestClearAllMuted()
                                } label: {
                                    Text("Clear All Muted")
                                }
                                .accessibilityHint("Removes mute settings from all muted conversations")
                            }

                            if !pinnedConversationIDs.isEmpty {
                                Button(role: .destructive) {
                                    requestClearAllPinned()
                                } label: {
                                    Text("Clear All Pinned")
                                }
                                .accessibilityHint("Removes pin settings from all pinned conversations")
                            }
                        }
                        .accessibilityLabel("Conversation actions")
                        .accessibilityHint("Opens bulk actions for visible conversations")
                    }
                }

                if canReorderPinned {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(editMode == .active ? "Done" : "Edit Pins") {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                editMode = editMode == .active ? .inactive : .active
                            }
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .overlay(alignment: .bottom) {
                if isToastVisible {
                    HStack(spacing: 10) {
                        Image(systemName: toastSystemImage)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(toastMessage)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white)

                            if let toastSubtitle {
                                Text(toastSubtitle)
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.92))
                            }

                            if let toastHint {
                                Text(toastHint)
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.82))
                            }
                        }

                        if pendingUndoAction != nil {
                            Divider()
                                .frame(height: 14)
                                .overlay(Color.white.opacity(0.25))

                            Button("Undo") {
                                performUndoAction()
                            }
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .accessibilityLabel("Undo last conversation action")
                            .accessibilityHint("Restores the previous mute or pin state")
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.82))
                    .clipShape(Capsule())
                    .padding(.bottom, 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(toastAccessibilityText)
                }
            }
            .searchable(text: $searchText, prompt: "Search by name, item, or message")
            .onChange(of: canReorderPinned) { _, isAllowed in
                if !isAllowed, editMode == .active {
                    editMode = .inactive
                }
            }
            .onAppear {
                if let currentUserId = currentUser?.uid {
                    viewModel.startListeningConversations(currentUserId: currentUserId)
                }
            }
            .onDisappear {
                viewModel.stopListeningConversations()
            }
            .refreshable {
                if let currentUserId = currentUser?.uid {
                    await viewModel.loadConversations(currentUserId: currentUserId)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
            .confirmationDialog(
                "Confirm Bulk Action",
                isPresented: Binding(
                    get: { pendingBulkAction != nil },
                    set: { isPresented in
                        if !isPresented {
                            pendingBulkAction = nil
                        }
                    }
                ),
                titleVisibility: .visible,
                presenting: pendingBulkAction
            ) { pending in
                Button(pending.buttonTitle, role: .destructive) {
                    performBulkAction(pending.type)
                    pendingBulkAction = nil
                }

                Button("Cancel", role: .cancel) {
                    pendingBulkAction = nil
                }
            } message: { pending in
                Text(pending.message)
            }
        }
    }

    private var filterChipsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ConversationFilter.allCases) { filter in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedFilter = filter
                        }
                    } label: {
                        Text(filter.title)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(selectedFilter == filter ? .white : .primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                selectedFilter == filter
                                ? Color.kuetGreen
                                : Color.secondary.opacity(0.14)
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }

                if !pinnedConversationIDs.isEmpty {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            prioritizeUnreadPinned.toggle()
                        }
                    } label: {
                        Text("Pinned: Unread First")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(prioritizeUnreadPinned ? .white : .primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                prioritizeUnreadPinned
                                ? Color.kuetGreen
                                : Color.secondary.opacity(0.14)
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)

            Text("Pinned: \(summaryPinnedCount)  •  Muted: \(summaryMutedCount)  •  Unread: \(summaryUnreadCount)")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        }
    }

    private func conversationRow(_ conversation: Conversation, currentUserId: String) -> some View {
        let unread = conversation.unread(for: currentUserId)
        let isMuted = conversation.id.map(isConversationMuted) ?? false
        let displayName = conversation.displayName(for: currentUserId)

        return NavigationLink(destination: ChatView(conversation: conversation)) {
            HStack(spacing: 12) {
                // Avatar
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Circle()
                            .fill(Color.kuetGreen.opacity(0.15))
                            .frame(width: 48, height: 48)
                        Text(String(displayName.prefix(1)).uppercased())
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.kuetGreen)
                    }
                    
                    if let otherUserId = conversation.participants.first(where: { $0 != currentUserId }),
                       let activity = activityStatus(for: conversation.lastActiveDate(for: otherUserId)),
                       activity.isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(displayName)
                            .fontWeight(.semibold)

                        if let conversationId = conversation.id,
                           isConversationPinned(conversationId) {
                            Image(systemName: "pin.fill")
                                .font(.caption2)
                                .foregroundStyle(Color.kuetGreen)
                        }

                        if let conversationId = conversation.id,
                           isConversationMuted(conversationId) {
                            Image(systemName: "bell.slash.fill")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                        Text(conversation.lastMessageTime, style: .relative)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if let itemTitle = conversation.itemTitle, !itemTitle.isEmpty {
                        Text(itemTitle)
                            .font(.caption)
                            .foregroundStyle(Color.kuetGreen)
                            .lineLimit(1)
                    }

                    HStack {
                        Text(conversation.lastMessage)
                            .lineLimit(1)
                            .font(.subheadline)
                            .fontWeight(unread > 0 ? .semibold : .regular)
                            .foregroundStyle(unread > 0 ? .primary : .secondary)

                        Spacer()

                        if isMuted {
                            Label("Muted", systemImage: "bell.slash.fill")
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color.secondary.opacity(0.14))
                                .clipShape(Capsule())
                                .transition(.scale(scale: 0.9).combined(with: .opacity))
                        }

                        if unread > 0 {
                            Text(unread > 99 ? "99+" : "\(unread)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .clipShape(Capsule())
                    }
                    }
                    .animation(.spring(response: 0.24, dampingFraction: 0.88), value: isMuted)
                }
            }
            .padding(.vertical, 4)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            if let conversationId = conversation.id {
                Button {
                    toggleConversationPin(conversationId)
                } label: {
                    Label(
                        isConversationPinned(conversationId) ? "Unpin" : "Pin",
                        systemImage: isConversationPinned(conversationId) ? "pin.slash" : "pin"
                    )
                }
                .tint(Color.kuetGreen)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if unread > 0, let conversationId = conversation.id {
                Button {
                    Task {
                        await viewModel.markRead(conversationId: conversationId, userId: currentUserId)
                    }
                } label: {
                    Label("Mark Read", systemImage: "checkmark.circle")
                }
                .tint(.green)
            }
        }
        .contextMenu {
            Button {
                UIPasteboard.general.string = conversation.lastMessage
                showCopiedMessageToast()
            } label: {
                Label("Copy Last Message", systemImage: "doc.on.doc")
            }

            if unread > 0, let conversationId = conversation.id {
                Button {
                    Task {
                        await viewModel.markRead(conversationId: conversationId, userId: currentUserId)
                    }
                } label: {
                    Label("Mark Read", systemImage: "checkmark.circle")
                }
            }

            if let conversationId = conversation.id {
                Button {
                    toggleConversationPin(conversationId)
                } label: {
                    Label(
                        isConversationPinned(conversationId) ? "Unpin Conversation" : "Pin Conversation",
                        systemImage: isConversationPinned(conversationId) ? "pin.slash" : "pin"
                    )
                }

                Button {
                    toggleConversationMute(conversationId)
                } label: {
                    let muted = isConversationMuted(conversationId)
                    Label(
                        muted ? "Unmute Notifications" : "Mute Notifications",
                        systemImage: muted ? "bell.badge" : "bell.slash"
                    )
                }
            }
        }
    }

    private func activityStatus(for date: Date?) -> (label: String, isOnline: Bool)? {
        guard let date else { return nil }

        let elapsed = Date().timeIntervalSince(date)
        if elapsed <= 90 {
            return ("Active now", true)
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        let relative = formatter.localizedString(for: date, relativeTo: Date())
        return ("Active \(relative)", false)
    }

    private func isConversationMuted(_ conversationId: String) -> Bool {
        mutedConversationIDs.contains(conversationId)
    }

    private func isConversationPinned(_ conversationId: String) -> Bool {
        pinnedConversationIDs.contains(conversationId)
    }

    private func toggleConversationMute(_ conversationId: String) {
        let previousMutedStateRaw = mutedConversationIDsRaw
        var ids = mutedConversationIDs

        if ids.contains(conversationId) {
            ids.remove(conversationId)
        } else {
            ids.insert(conversationId)
        }

        let isNowMuted = ids.contains(conversationId)
        mutedConversationIDsRaw = ids.sorted().joined(separator: ",")

        showToast(
            message: isNowMuted ? "Conversation muted" : "Conversation unmuted",
            subtitle: isNowMuted ? "Last action: Muted this conversation" : "Last action: Unmuted this conversation",
            systemImage: isNowMuted ? "bell.slash.fill" : "bell.badge",
            dismissAfterNanoseconds: 2_500_000_000,
            undoAction: .restoreMutedState(previousMutedStateRaw)
        )
    }

    private func toggleConversationPin(_ conversationId: String) {
        var ids = pinnedConversationIDs
        var orderedIds = pinnedConversationOrder.filter { ids.contains($0) }

        if ids.contains(conversationId) {
            ids.remove(conversationId)
            orderedIds.removeAll { $0 == conversationId }
        } else {
            ids.insert(conversationId)
            orderedIds.removeAll { $0 == conversationId }
            orderedIds.insert(conversationId, at: 0)
        }

        pinnedConversationIDsRaw = ids.sorted().joined(separator: ",")
        pinnedConversationOrderRaw = orderedIds.joined(separator: ",")
    }

    private func movePinnedConversations(from source: IndexSet, to destination: Int) {
        guard canReorderPinned else { return }

        var orderedIds = pinnedConversationOrder
        let visiblePinnedIds = pinnedConversations.compactMap(\.id)
        var visibleOrder = visiblePinnedIds

        visibleOrder.move(fromOffsets: source, toOffset: destination)

        // Rebuild global pinned order by replacing visible pinned IDs in-place.
        var iterator = visibleOrder.makeIterator()
        for index in orderedIds.indices {
            if visiblePinnedIds.contains(orderedIds[index]), let next = iterator.next() {
                orderedIds[index] = next
            }
        }

        pinnedConversationOrderRaw = orderedIds.joined(separator: ",")
    }

    private func markAllVisibleConversationsRead() {
        guard let currentUserId = currentUser?.uid else { return }

        let conversationIDs = visibleUnreadConversationIDs
        guard !conversationIDs.isEmpty else { return }

        let count = conversationIDs.count

        Task {
            for conversationId in conversationIDs {
                await viewModel.markRead(conversationId: conversationId, userId: currentUserId)
            }

            await MainActor.run {
                showToast(
                    message: "Marked \(count) as read",
                    subtitle: "Last action: Marked visible conversations read",
                    systemImage: "checkmark.circle.fill"
                )
            }
        }
    }

    private func requestBulkMarkAllRead() {
        let count = visibleUnreadConversationIDs.count
        guard count > 0 else { return }

        if count > 20 {
            pendingBulkAction = PendingBulkAction(type: .markRead, count: count)
        } else {
            markAllVisibleConversationsRead()
        }
    }

    private func requestBulkMuteVisible() {
        let count = visibleUnmutedConversationIDs.count
        guard count > 0 else { return }

        if count > 20 {
            pendingBulkAction = PendingBulkAction(type: .mute, count: count)
        } else {
            setMutedForVisibleConversations(true)
        }
    }

    private func requestBulkUnmuteVisible() {
        let count = visibleMutedConversationIDs.count
        guard count > 0 else { return }

        if count > 20 {
            pendingBulkAction = PendingBulkAction(type: .unmute, count: count)
        } else {
            setMutedForVisibleConversations(false)
        }
    }

    private func requestClearAllMuted() {
        let count = mutedConversationIDs.count
        guard count > 0 else { return }
        pendingBulkAction = PendingBulkAction(type: .clearAllMuted, count: count)
    }

    private func requestClearAllPinned() {
        let count = pinnedConversationIDs.count
        guard count > 0 else { return }
        pendingBulkAction = PendingBulkAction(type: .clearAllPinned, count: count)
    }

    private func performBulkAction(_ actionType: BulkActionType) {
        switch actionType {
        case .markRead:
            markAllVisibleConversationsRead()
        case .mute:
            setMutedForVisibleConversations(true)
        case .unmute:
            setMutedForVisibleConversations(false)
        case .clearAllMuted:
            clearAllMutedConversations()
        case .clearAllPinned:
            clearAllPinnedConversations()
        }
    }

    private func clearAllMutedConversations() {
        guard canRunDestructiveAction() else { return }

        let count = mutedConversationIDs.count
        guard count > 0 else { return }
        triggerWarningHaptic()

        let previousMutedStateRaw = mutedConversationIDsRaw
        mutedConversationIDsRaw = ""

        showToast(
            message: "Cleared \(count) muted conversations",
            subtitle: "Last action: Removed mute settings",
            systemImage: "bell.badge",
            dismissAfterNanoseconds: 2_500_000_000,
            undoAction: .restoreMutedState(previousMutedStateRaw)
        )
    }

    private func clearAllPinnedConversations() {
        guard canRunDestructiveAction() else { return }

        let count = pinnedConversationIDs.count
        guard count > 0 else { return }
        triggerWarningHaptic()

        let previousPinnedIDsRaw = pinnedConversationIDsRaw
        let previousPinnedOrderRaw = pinnedConversationOrderRaw
        pinnedConversationIDsRaw = ""
        pinnedConversationOrderRaw = ""

        showToast(
            message: "Cleared \(count) pinned conversations",
            subtitle: "Last action: Removed pin settings",
            systemImage: "pin.slash",
            dismissAfterNanoseconds: 2_500_000_000,
            undoAction: .restorePinnedState(previousPinnedIDsRaw, previousPinnedOrderRaw)
        )
    }

    private func setMutedForVisibleConversations(_ muted: Bool) {
        let idsToUpdate = muted ? visibleUnmutedConversationIDs : visibleMutedConversationIDs
        guard !idsToUpdate.isEmpty else { return }

        let count = idsToUpdate.count
        let previousMutedStateRaw = mutedConversationIDsRaw

        var ids = mutedConversationIDs
        if muted {
            ids.formUnion(idsToUpdate)
        } else {
            ids.subtract(idsToUpdate)
        }

        mutedConversationIDsRaw = ids.sorted().joined(separator: ",")
        showToast(
            message: muted ? "Muted \(count) conversations" : "Unmuted \(count) conversations",
            subtitle: muted ? "Last action: Disabled conversation notifications" : "Last action: Enabled conversation notifications",
            systemImage: muted ? "bell.slash.fill" : "bell.badge",
            dismissAfterNanoseconds: 2_500_000_000,
            undoAction: .restoreMutedState(previousMutedStateRaw)
        )
    }

    private func showCopiedMessageToast() {
        showToast(
            message: "Message copied",
            subtitle: "Last action: Copied last message to clipboard",
            systemImage: "doc.on.doc.fill"
        )
    }

    private func showToast(
        message: String,
        subtitle: String? = nil,
        systemImage: String,
        dismissAfterNanoseconds: UInt64 = 1_200_000_000,
        hint: String? = nil,
        undoAction: UndoAction? = nil
    ) {
        toastDismissTask?.cancel()
        toastMessage = message
        toastSubtitle = subtitle
        toastSystemImage = systemImage
        toastHint = hint ?? (undoAction != nil ? "Tap Undo to revert" : nil)
        pendingUndoAction = undoAction

        withAnimation(.easeOut(duration: 0.2)) {
            isToastVisible = true
        }

        toastDismissTask = Task {
            try? await Task.sleep(nanoseconds: dismissAfterNanoseconds)
            await MainActor.run {
                withAnimation(.easeIn(duration: 0.2)) {
                    isToastVisible = false
                }
                toastSubtitle = nil
                toastHint = nil
                pendingUndoAction = nil
            }
        }
    }

    private func performUndoAction() {
        guard let action = pendingUndoAction else { return }

        switch action {
        case .restoreMutedState(let rawValue):
            mutedConversationIDsRaw = rawValue
        case .restorePinnedState(let idsRaw, let orderRaw):
            pinnedConversationIDsRaw = idsRaw
            pinnedConversationOrderRaw = orderRaw
        }

        triggerSuccessHaptic()
        pendingUndoAction = nil
        showToast(
            message: "Undo complete",
            subtitle: "Last action: Restored previous state",
            systemImage: "arrow.uturn.backward.circle.fill"
        )
    }

    private func triggerWarningHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    private func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    private func canRunDestructiveAction() -> Bool {
        let now = Date()
        guard now.timeIntervalSince(lastDestructiveActionAt) >= destructiveActionCooldown else {
            triggerWarningHaptic()
            showToast(
                message: "Please wait a moment",
                subtitle: "Last action is still cooling down",
                systemImage: "hourglass"
            )
            return false
        }

        lastDestructiveActionAt = now
        return true
    }

    private var mutedConversationIDs: Set<String> {
        let ids = mutedConversationIDsRaw
            .split(separator: ",")
            .map { String($0) }
        return Set(ids)
    }

    private var pinnedConversationIDs: Set<String> {
        let ids = pinnedConversationIDsRaw
            .split(separator: ",")
            .map { String($0) }
        return Set(ids)
    }

    private var pinnedConversationOrder: [String] {
        let pinnedIds = pinnedConversationIDs
        let ordered = pinnedConversationOrderRaw
            .split(separator: ",")
            .map { String($0) }
            .filter { pinnedIds.contains($0) }

        let missing = pinnedIds.filter { !ordered.contains($0) }.sorted()
        return ordered + missing
    }
}

private enum UndoAction {
    case restoreMutedState(String)
    case restorePinnedState(String, String)
}

private struct PendingBulkAction {
    let type: BulkActionType
    let count: Int

    var buttonTitle: String {
        switch type {
        case .markRead:
            return "Mark \(count) Read"
        case .mute:
            return "Mute \(count) Conversations"
        case .unmute:
            return "Unmute \(count) Conversations"
        case .clearAllMuted:
            return "Clear \(count) Muted"
        case .clearAllPinned:
            return "Clear \(count) Pinned"
        }
    }

    var message: String {
        switch type {
        case .markRead:
            return "This will mark \(count) visible conversations as read."
        case .mute:
            return "This will mute notifications for \(count) visible conversations."
        case .unmute:
            return "This will unmute notifications for \(count) visible conversations."
        case .clearAllMuted:
            return "This will clear mute settings for all \(count) muted conversations."
        case .clearAllPinned:
            return "This will remove pin settings for all \(count) pinned conversations."
        }
    }
}

private enum BulkActionType {
    case markRead
    case mute
    case unmute
    case clearAllMuted
    case clearAllPinned
}

private enum ConversationFilter: String, CaseIterable, Identifiable {
    case all
    case unread
    case muted

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .unread:
            return "Unread"
        case .muted:
            return "Muted"
        }
    }
}

#Preview {
    ConversationsListView()
}

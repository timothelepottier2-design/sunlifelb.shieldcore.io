(function () {
	'use strict';

	// ===== Constantes =====
	// Doit rester synchronisé avec Config.MaxSendSalary (server/config.lua).
	var MAX_SEND_SALARY = 20000000;

	// ===== DOM refs =====
	var app = document.getElementById('app');

	// Header (haut du content)
	var headerTitle    = document.getElementById('headerTitle');
	var headerSubtitle = document.getElementById('headerSubtitle');
	var balanceDisplay = document.getElementById('balanceDisplay');
	var balancePill    = document.getElementById('balancePillValue');
	var balanceInline  = document.getElementById('balanceInline');

	// Sidebar footer
	var footerBalance = document.getElementById('footerBalance');
	var footerSociety = document.getElementById('footerSociety');

	// Sidebar counters
	var navMembersCount = document.getElementById('navMembersCount');
	var navServiceCount = document.getElementById('navServiceCount');

	// Compte société
	var journalList   = document.getElementById('journalList');
	var kpiEntrees    = document.getElementById('kpiEntrees');
	var kpiSorties    = document.getElementById('kpiSorties');
	var btnDeposit    = document.getElementById('btnDeposit');
	var btnWithdraw   = document.getElementById('btnWithdraw');

	// Membres
	var membersBody = document.getElementById('membersBody');
	var btnRecruit  = document.getElementById('btnRecruit');

	// Salaires
	var salaryHistoryList         = document.getElementById('salaryHistoryList');
	var btnSendSalary             = document.getElementById('btnSendSalary');
	var modalSendSalary           = document.getElementById('modalSendSalary');
	var sendSalaryEmployeeSelect  = document.getElementById('sendSalaryEmployeeSelect');
	var sendSalaryAmountInput     = document.getElementById('sendSalaryAmountInput');
	var modalSendSalaryCancel     = document.getElementById('modalSendSalaryCancel');
	var modalSendSalaryConfirm    = document.getElementById('modalSendSalaryConfirm');

	// Facturation
	var invoicesList       = document.getElementById('invoicesList');
	var btnRefreshInvoices = document.getElementById('btnRefreshInvoices');

	// Service
	var serviceCurrentList   = document.getElementById('serviceCurrentList');
	var serviceSessionsBody  = document.getElementById('serviceSessionsBody');
	var btnRefreshService    = document.getElementById('btnRefreshService');

	// Permissions
	var permissionsThead   = document.getElementById('permissionsThead');
	var permissionsBody    = document.getElementById('permissionsBody');
	var btnSavePermissions = document.getElementById('btnSavePermissions');

	// Webhook
	var webhookInput   = document.getElementById('webhookInput');
	var btnSaveWebhook = document.getElementById('btnSaveWebhook');

	// Boutons fermer
	var btnClose       = document.getElementById('btnClose');
	var btnHeaderClose = document.getElementById('btnHeaderClose');

	// Modaux
	var modalAmount        = document.getElementById('modalAmount');
	var modalAmountTitle   = document.getElementById('modalAmountTitle');
	var modalAmountInput   = document.getElementById('modalAmountInput');
	var modalAmountCancel  = document.getElementById('modalAmountCancel');
	var modalAmountConfirm = document.getElementById('modalAmountConfirm');

	var modalRecruit         = document.getElementById('modalRecruit');
	var recruitPlayerSelect  = document.getElementById('recruitPlayerSelect');
	var recruitGradeSelect   = document.getElementById('recruitGradeSelect');
	var modalRecruitCancel   = document.getElementById('modalRecruitCancel');
	var modalRecruitConfirm  = document.getElementById('modalRecruitConfirm');

	var modalGrade        = document.getElementById('modalGrade');
	var modalGradeTitle   = document.getElementById('modalGradeTitle');
	var gradeSelect       = document.getElementById('gradeSelect');
	var modalGradeCancel  = document.getElementById('modalGradeCancel');
	var modalGradeConfirm = document.getElementById('modalGradeConfirm');

	var modalConfirm        = document.getElementById('modalConfirm');
	var modalConfirmTitle   = document.getElementById('modalConfirmTitle');
	var modalConfirmMessage = document.getElementById('modalConfirmMessage');
	var modalConfirmCancel  = document.getElementById('modalConfirmCancel');
	var modalConfirmOk      = document.getElementById('modalConfirmOk');
	var pendingConfirmCb    = null;

	// ===== State =====
	var chartInstance = null;
	var state = {
		society: null,
		balance: 0,
		transactions: [],
		graphData: [],
		employees: [],
		jobGrades: [],
		unemployed: [],
		salaryHistory: [],
		invoices: [],
		serviceCurrent: [],
		serviceSessions: [],
		serviceFilter: 'day',
		washMoneyAllowed: false,
		permissions: [],
		permissionLabels: {},
		societyWebhook: '',
		currentIdentifier: ''
	};

	// ===== Helpers =====
	function escapeHTML(s) {
		var map = { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' };
		return String(s == null ? '' : s).replace(/[&<>"']/g, function (m) { return map[m]; });
	}

	function formatMoney(n) {
		var num = Number(n);
		if (isNaN(num)) return '0 $';
		return num.toLocaleString('fr-FR', { minimumFractionDigits: 0, maximumFractionDigits: 2 }) + ' $';
	}

	function formatDate(ts) {
		var d = new Date(ts * 1000);
		var day = String(d.getDate()).padStart(2, '0');
		var month = String(d.getMonth() + 1).padStart(2, '0');
		var year = d.getFullYear();
		return day + '/' + month + '/' + String(year).slice(-2);
	}

	function formatTime(ts) {
		var d = new Date(ts * 1000);
		var h = String(d.getHours()).padStart(2, '0');
		var m = String(d.getMinutes()).padStart(2, '0');
		return h + ':' + m;
	}

	function formatDuration(seconds) {
		if (seconds == null || seconds < 0) return '—';
		var h = Math.floor(seconds / 3600);
		var m = Math.floor((seconds % 3600) / 60);
		if (h > 0) return h + ' h ' + m + ' min';
		return m + ' min';
	}

	function formatAxisMoney(value) {
		if (value >= 1000000) return (value / 1000000).toFixed(1).replace('.', ',') + ' M';
		if (value >= 1000)    return (value / 1000).toFixed(0) + ' K';
		return String(value);
	}

	function post(action, data) {
		var url = 'https://' + (window.GetParentResourceName && GetParentResourceName()) + '/' + action;
		fetch(url, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(data || {})
		}).catch(function () {});
	}

	// Message d'erreur non bloquant (NE JAMAIS utiliser alert()/confirm() dans un
	// NUI FiveM : ça bloque le rendu CEF et fige tout le menu + la souris).
	function showInlineError(afterEl, msg) {
		if (!afterEl || !afterEl.parentNode) return;
		var parent = afterEl.parentNode;
		var err = parent.querySelector('.inline-error');
		if (!err) {
			err = document.createElement('div');
			err.className = 'inline-error';
			afterEl.insertAdjacentElement('afterend', err);
		}
		err.textContent = msg;
		err.style.display = 'block';
		if (err._t) clearTimeout(err._t);
		err._t = setTimeout(function () { err.style.display = 'none'; }, 3000);
	}

	// ===========================================================================
	//  CUSTOM SELECT
	//  Le <select> natif buggé dans CEF/FiveM (le dropdown affiche un screenshot
	//  de l'UI au lieu des options). On wrap le <select> dans une UI custom :
	//  - le <select> reste dans le DOM (caché) et garde sa .value/.options[…]
	//    pour que le code existant (recruitGradeSelect.value, etc.) marche tel quel
	//  - un <button> trigger + un <ul> panel sont créés à côté
	//  - chaque rebuild du <select> (innerHTML = ...) déclenche un rebuild du panel
	// ===========================================================================
	function enhanceSelect(selectEl) {
		if (!selectEl || selectEl._csEnhanced) return;
		selectEl._csEnhanced = true;

		// Wrapper
		var wrap = document.createElement('div');
		wrap.className = 'cs-wrap';
		selectEl.parentNode.insertBefore(wrap, selectEl);
		wrap.appendChild(selectEl);
		selectEl.style.display = 'none';
		selectEl.setAttribute('aria-hidden', 'true');

		// Trigger
		var trigger = document.createElement('button');
		trigger.type = 'button';
		trigger.className = 'cs-trigger';
		trigger.innerHTML =
			'<span class="cs-value placeholder">--</span>' +
			'<i class="cs-arrow fas fa-chevron-down"></i>';
		wrap.appendChild(trigger);

		// Panel
		var panel = document.createElement('div');
		panel.className = 'cs-panel';
		wrap.appendChild(panel);

		var triggerLabel = trigger.querySelector('.cs-value');

		function syncFromSelect() {
			panel.innerHTML = '';
			var opts = selectEl.options;
			if (!opts || opts.length === 0) {
				var emptyEl = document.createElement('div');
				emptyEl.className = 'cs-option empty';
				emptyEl.textContent = 'Aucune option';
				panel.appendChild(emptyEl);
				triggerLabel.textContent = '--';
				triggerLabel.classList.add('placeholder');
				return;
			}

			var selectedIdx = selectEl.selectedIndex;
			for (var i = 0; i < opts.length; i++) {
				(function (idx) {
					var o = opts[idx];
					var item = document.createElement('div');
					item.className = 'cs-option';
					if (idx === selectedIdx) item.classList.add('selected');
					if (!o.value) item.classList.add('placeholder');
					item.textContent = o.textContent || o.label || o.value || '';
					item.addEventListener('click', function (ev) {
						ev.stopPropagation();
						selectEl.selectedIndex = idx;
						// Déclenche un event change synthétique au cas où du code écoute
						var evt;
						try { evt = new Event('change', { bubbles: true }); } catch (_) { evt = document.createEvent('Event'); evt.initEvent('change', true, true); }
						selectEl.dispatchEvent(evt);
						closePanel();
						refreshTriggerLabel();
					});
					panel.appendChild(item);
				})(i);
			}
			refreshTriggerLabel();
		}

		function refreshTriggerLabel() {
			var idx = selectEl.selectedIndex;
			if (idx < 0 || !selectEl.options[idx] || !selectEl.options[idx].value) {
				triggerLabel.textContent = (selectEl.options[0] && selectEl.options[0].textContent) || '-- Choisir --';
				triggerLabel.classList.add('placeholder');
			} else {
				triggerLabel.textContent = selectEl.options[idx].textContent || selectEl.options[idx].value;
				triggerLabel.classList.remove('placeholder');
			}
		}

		function openPanel() {
			// Ferme tous les autres panels ouverts
			document.querySelectorAll('.cs-panel.open').forEach(function (p) { if (p !== panel) p.classList.remove('open'); });
			document.querySelectorAll('.cs-trigger.open').forEach(function (t) { if (t !== trigger) t.classList.remove('open'); });
			syncFromSelect();
			panel.classList.add('open');
			trigger.classList.add('open');
		}
		function closePanel() {
			panel.classList.remove('open');
			trigger.classList.remove('open');
		}
		function togglePanel() {
			if (panel.classList.contains('open')) closePanel(); else openPanel();
		}

		trigger.addEventListener('click', function (ev) {
			ev.stopPropagation();
			togglePanel();
		});

		// Fermer si on clique ailleurs
		document.addEventListener('click', function (ev) {
			if (!wrap.contains(ev.target)) closePanel();
		});

		// Observer le <select> pour rebuild quand le code fait .innerHTML = ...
		var mo = new MutationObserver(function () {
			if (panel.classList.contains('open')) {
				syncFromSelect();
			} else {
				refreshTriggerLabel();
			}
		});
		mo.observe(selectEl, { childList: true, subtree: true, attributes: true, attributeFilter: ['value'] });

		// Init
		syncFromSelect();
	}

	// On enhance les selects présents au chargement.
	function enhanceAllSelects() {
		document.querySelectorAll('.modal-body select').forEach(function (s) { enhanceSelect(s); });
	}
	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', enhanceAllSelects);
	} else {
		enhanceAllSelects();
	}

	function closeUI() {
		var b = document.body;
		b.style.display = 'none';
		b.setAttribute('data-closed', '1');
		b.classList.add('ui-closed');
		if (app) app.classList.add('hidden');
	}

	function openUI() {
		var b = document.body;
		b.style.display = '';
		b.removeAttribute('data-closed');
		b.classList.remove('ui-closed');
		if (app) app.classList.remove('hidden');
	}

	// ===== Header / titres =====
	var VIEW_TITLES = {
		compte:      ['Compte société', 'Aperçu et trésorerie'],
		membres:     ['Membres',        'Recrutement, grades et licenciements'],
		salaires:    ['Salaires',       'Versement des salaires et primes'],
		facturation: ['Facturation',    "Factures reçues par l'entreprise"],
		service:     ['Service',        'Employés en poste et historique'],
		blanchiment: ['Blanchiment',    "Transformer l'argent sale en liquide"],
		permissions: ['Permissions',    'Droits par grade'],
		parametres:  ['Paramètres',     'Webhook Discord et configuration']
	};

	function setHeader(viewKey) {
		var t = VIEW_TITLES[viewKey] || ['Entreprise', ''];
		headerTitle.textContent = t[0];
		headerSubtitle.textContent = t[1];
	}

	// ===== Navigation =====
	document.querySelectorAll('.nav-item').forEach(function (btn) {
		btn.addEventListener('click', function () {
			var view = this.getAttribute('data-view');
			if (!view) return;
			document.querySelectorAll('.nav-item').forEach(function (b) { b.classList.remove('active'); });
			document.querySelectorAll('.biz-panel').forEach(function (v) { v.classList.remove('active'); });
			this.classList.add('active');
			var panel = document.getElementById('view-' + view);
			if (panel) panel.classList.add('active');
			setHeader(view);

			if (view === 'parametres' && webhookInput) {
				webhookInput.value = state.societyWebhook || '';
			}
			if (view === 'permissions') {
				post('getPermissions');
			}
		});
	});

	if (btnClose)       btnClose.addEventListener('click', function () { closeUI(); post('close'); });
	if (btnHeaderClose) btnHeaderClose.addEventListener('click', function () { closeUI(); post('close'); });

	// ===== Balance / KPI / footer =====
	function renderBalance() {
		var s = formatMoney(state.balance);
		if (balancePill)    balancePill.textContent = s;
		if (balanceInline)  balanceInline.textContent = s;
		if (footerBalance)  footerBalance.textContent = s;
	}

	function renderKpis() {
		var totEntrees = 0, totSorties = 0;
		(state.graphData || []).forEach(function (d) {
			totEntrees += Number(d.entrees) || 0;
			totSorties += Number(d.sorties) || 0;
		});
		if (kpiEntrees) kpiEntrees.textContent = formatMoney(totEntrees);
		if (kpiSorties) kpiSorties.textContent = formatMoney(totSorties);
	}

	function renderFooterSociety() {
		if (!footerSociety) return;
		footerSociety.textContent = state.society || '—';
	}

	function renderCounts() {
		if (navMembersCount) navMembersCount.textContent = String((state.employees || []).length);
		if (navServiceCount) navServiceCount.textContent = String((state.serviceCurrent || []).length);
	}

	// ===== Journal =====
	function renderJournal() {
		if (!state.transactions || state.transactions.length === 0) {
			journalList.innerHTML = '<p class="empty">Aucun mouvement.</p>';
			return;
		}
		journalList.innerHTML = state.transactions.map(function (t) {
			var isEntree = t.type === 'deposit';
			// Le serveur renvoie maintenant un `label` détaillé (Vente / encaissement,
			// Dépôt patron, Retrait patron, Salaire envoyé, Facture payée, Impôt…).
			// Fallback sur Dépôt/Retrait pour les anciennes lignes pré-migration.
			var label = (t.label && String(t.label).trim()) ? String(t.label) : (isEntree ? 'Dépôt' : 'Retrait');
			var cls   = isEntree ? 'entree' : 'sortie';
			var sign  = isEntree ? '+' : '−';
			return '<div class="journal-item">' +
				'<span><span class="label">' + escapeHTML(label) + '</span><span class="date">' + formatDate(t.created_at) + '</span></span>' +
				'<span class="amount ' + cls + '">' + sign + ' ' + formatMoney(t.amount) + '</span></div>';
		}).join('');
	}

	// ===== Chart =====
	function buildChart() {
		var canvas  = document.getElementById('chartCompte');
		var emptyEl = document.getElementById('chartEmptyState');
		if (!canvas) return;
		if (typeof Chart === 'undefined') {
			if (emptyEl) { emptyEl.textContent = 'Graphique indisponible'; emptyEl.style.display = 'flex'; }
			return;
		}
		var ctx = canvas.getContext('2d');
		if (chartInstance) chartInstance.destroy();

		var raw = state.graphData || [];
		var hasData = raw.length > 0;
		var labels, entrees, sorties;

		if (hasData) {
			labels = raw.map(function (d) {
				var parts = (d.day || '').split('-');
				return (parts[2] || '').replace(/^0/, '') + '/' + (parts[1] || '');
			});
			entrees = raw.map(function (d) { return Number(d.entrees) || 0; });
			sorties = raw.map(function (d) { return Number(d.sorties) || 0; });
		} else {
			var days = [];
			for (var i = 6; i >= 0; i--) {
				var d = new Date();
				d.setDate(d.getDate() - i);
				days.push(d.getDate() + '/' + (d.getMonth() + 1));
			}
			labels = days;
			entrees = [0, 0, 0, 0, 0, 0, 0];
			sorties = [0, 0, 0, 0, 0, 0, 0];
		}

		var maxVal = 1;
		if (hasData) {
			entrees.forEach(function (v) { if (v > maxVal) maxVal = v; });
			sorties.forEach(function (v) { if (v > maxVal) maxVal = v; });
		}

		chartInstance = new Chart(ctx, {
			type: 'bar',
			data: {
				labels: labels,
				datasets: [
					{
						label: 'Entrées',
						data: entrees,
						backgroundColor: 'rgba(74, 222, 128, .85)',
						borderColor: '#4ade80',
						borderWidth: 0,
						borderRadius: 4,
						barPercentage: 0.75,
						categoryPercentage: 0.8
					},
					{
						label: 'Sorties',
						data: sorties,
						backgroundColor: 'rgba(255, 92, 122, .85)',
						borderColor: '#ff5c7a',
						borderWidth: 0,
						borderRadius: 4,
						barPercentage: 0.75,
						categoryPercentage: 0.8
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					legend: { display: false },
					tooltip: {
						backgroundColor: 'rgba(15,15,18,.95)',
						borderColor: 'rgba(255,215,0,.25)',
						borderWidth: 1,
						titleColor: '#ffd700',
						bodyColor: '#fff',
						padding: 10,
						callbacks: {
							label: function (item) {
								return (item.dataset.label || '') + ': ' + formatMoney(item.raw);
							}
						}
					}
				},
				scales: {
					x: {
						grid: { display: false },
						ticks: { color: 'rgba(255,255,255,.4)', maxRotation: 0, font: { size: 10, family: 'Inter' } }
					},
					y: {
						min: 0,
						suggestedMax: maxVal > 0 ? maxVal * 1.15 : 100,
						grid: { color: 'rgba(255,255,255,.05)' },
						ticks: {
							color: 'rgba(255,255,255,.4)',
							font: { size: 10, family: 'Inter' },
							callback: function (value) { return formatAxisMoney(value); }
						}
					}
				}
			}
		});

		if (emptyEl) {
			emptyEl.style.display = hasData ? 'none' : 'flex';
			if (!hasData) emptyEl.textContent = 'Aucune donnée sur la période';
		}
	}

	// ===== Modal montant (deposit / withdraw) =====
	var pendingAmountAction = null;

	function openAmountModal(title, action) {
		pendingAmountAction = action;
		modalAmountTitle.textContent = title;
		modalAmountInput.value = '';
		modalAmount.classList.remove('hidden');
		setTimeout(function () { modalAmountInput.focus(); }, 30);
	}

	function closeAmountModal() {
		modalAmount.classList.add('hidden');
		pendingAmountAction = null;
	}

	if (modalAmountCancel) modalAmountCancel.addEventListener('click', closeAmountModal);
	if (modalAmountConfirm) modalAmountConfirm.addEventListener('click', function () {
		var amount = parseInt(modalAmountInput.value, 10);
		if (!amount || amount <= 0) return;
		if (pendingAmountAction) post(pendingAmountAction, { amount: amount });
		closeAmountModal();
	});
	if (modalAmountInput) modalAmountInput.addEventListener('keydown', function (e) {
		if (e.key === 'Enter') modalAmountConfirm.click();
	});

	if (btnDeposit)  btnDeposit.addEventListener('click',  function () { openAmountModal('Montant du dépôt',  'deposit');  });
	if (btnWithdraw) btnWithdraw.addEventListener('click', function () { openAmountModal('Montant du retrait', 'withdraw'); });

	// ===== Modal confirmation (évite window.confirm qui fige le NUI FiveM) =====
	function openConfirmModal(title, message, onConfirm) {
		pendingConfirmCb = onConfirm || null;
		if (modalConfirmTitle)   modalConfirmTitle.textContent = title || 'Confirmation';
		if (modalConfirmMessage) modalConfirmMessage.textContent = message || '';
		if (modalConfirm)        modalConfirm.classList.remove('hidden');
	}

	function closeConfirmModal() {
		if (modalConfirm) modalConfirm.classList.add('hidden');
		pendingConfirmCb = null;
	}

	if (modalConfirmCancel) modalConfirmCancel.addEventListener('click', closeConfirmModal);
	if (modalConfirmOk) modalConfirmOk.addEventListener('click', function () {
		var cb = pendingConfirmCb;
		closeConfirmModal();
		if (cb) cb();
	});

	// ===== Members =====
	function renderMembers() {
		var list = state.employees || [];
		if (list.length === 0) {
			membersBody.innerHTML = '<tr><td colspan="4" class="empty">Aucun membre.</td></tr>';
			return;
		}
		membersBody.innerHTML = list.map(function (emp) {
			var name = ((emp.firstname || '') + ' ' + (emp.lastname || '')).trim() || '—';
			var gradeLabel = emp.job && (emp.job.grade_label || emp.job.label) ? emp.job.grade_label : '-';
			var status = emp.connected
				? '<span class="status-online">En ligne</span>'
				: '<span class="status-offline">Hors ligne</span>';
			var isBoss = emp.job && emp.job.grade_name === 'boss';
			var isSelf = state.currentIdentifier && emp.identifier === state.currentIdentifier;
			// Badge "multi-job" : l'employé a CETTE société en job 2 (pas son job actif).
			// Le bouton Virer reste actif mais la suppression se fait via fromSociety
			// côté serveur (cf. esx_society/server/main.lua), donc on ne perd jamais
			// son job principal.
			var multiBadge = emp.is_multi ? ' <span class="multi-tag">multi-job</span>' : '';

			var actions = '';
			if (isBoss && isSelf) {
				// Auto-licenciement interdit : on n'affiche aucune action sur sa propre ligne.
				actions = '<span class="actions-patron">Patron (vous)</span>';
			} else if (isBoss) {
				// Autre patron : un boss peut virer un autre boss, mais pas grader/dégrader
				// (boss étant le grade le plus élevé). La logique serveur valide l'opération.
				actions = '<div class="actions-stack">' +
					'<button type="button" class="btn btn-sm btn-fire" data-action="fire" data-id="' + escapeHTML(emp.identifier || '') + '" data-isboss="1">' +
						'<i class="fas fa-user-slash"></i><span>Virer</span></button>' +
					'</div>';
			} else {
				actions = '<div class="actions-stack">' +
					'<button type="button" class="btn btn-sm btn-promote" data-action="promote" data-id="' + escapeHTML(emp.identifier || '') + '">' +
						'<i class="fas fa-arrow-up"></i><span>Grader</span></button>' +
					'<button type="button" class="btn btn-sm btn-demote"  data-action="demote"  data-id="' + escapeHTML(emp.identifier || '') + '">' +
						'<i class="fas fa-arrow-down"></i><span>Dégrader</span></button>' +
					'<button type="button" class="btn btn-sm btn-fire"    data-action="fire"    data-id="' + escapeHTML(emp.identifier || '') + '">' +
						'<i class="fas fa-user-slash"></i><span>Virer</span></button>' +
					'</div>';
			}

			var bossTag = (isBoss && !isSelf) ? ' <span class="boss-tag">Patron</span>' : '';

			return '<tr>' +
				'<td class="member-name">' + escapeHTML(name) + bossTag + multiBadge + '</td>' +
				'<td class="member-grade">' + escapeHTML(gradeLabel) + ' <span class="grade-num">(' + escapeHTML(emp.job ? emp.job.grade : '-') + ')</span></td>' +
				'<td class="member-status">' + status + '</td>' +
				'<td class="actions-cell ta-right">' + actions + '</td>' +
			'</tr>';
		}).join('');

		membersBody.querySelectorAll('[data-action]').forEach(function (btn) {
			btn.addEventListener('click', function () {
				var action = this.getAttribute('data-action');
				var id     = this.getAttribute('data-id');
				if (action === 'fire') {
					post('fire', { identifier: id });
					return;
				}
				if (action === 'promote' || action === 'demote') openGradeModal(action, id);
			});
		});
	}

	function openGradeModal(action, identifier) {
		var grades = (state.jobGrades || []).filter(function (g) { return g.name !== 'boss'; });
		gradeSelect.innerHTML = '<option value="">-- Grade --</option>' +
			grades.map(function (g) {
				return '<option value="' + escapeHTML(g.grade) + '">' + escapeHTML(g.label || g.name) + '</option>';
			}).join('');
		modalGradeTitle.textContent = action === 'promote' ? 'Promouvoir (Grader)' : 'Dégrader';
		modalGrade.dataset.action = action;
		modalGrade.dataset.identifier = identifier || '';
		modalGrade.classList.remove('hidden');
	}

	if (modalGradeCancel)  modalGradeCancel.addEventListener('click', function () { modalGrade.classList.add('hidden'); });
	if (modalGradeConfirm) modalGradeConfirm.addEventListener('click', function () {
		var grade = gradeSelect.value;
		if (!grade) return;
		post(modalGrade.dataset.action, { identifier: modalGrade.dataset.identifier, grade: parseInt(grade, 10) });
		modalGrade.classList.add('hidden');
	});

	// ===== Recruit =====
	if (btnRecruit) btnRecruit.addEventListener('click', function () {
		post('getUnemployed');
	});

	function openRecruitModal() {
		var players = state.unemployed || [];
		recruitPlayerSelect.innerHTML = '<option value="">-- Choisir --</option>' +
			players.map(function (p) {
				var name = (p.label && p.label.trim())
					? p.label
					: (((p.firstname || '') + ' ' + (p.lastname || '')).trim() || ('Joueur #' + (p.identifier || '').slice(-6)));
				return '<option value="' + escapeHTML(p.identifier || '') + '">' + escapeHTML(name || '—') + '</option>';
			}).join('');
		var grades = (state.jobGrades || []).filter(function (g) { return g.name !== 'boss'; });
		recruitGradeSelect.innerHTML = '<option value="">-- Grade --</option>' +
			grades.map(function (g) {
				return '<option value="' + escapeHTML(g.grade) + '">' + escapeHTML(g.label || g.name) + '</option>';
			}).join('');
		modalRecruit.classList.remove('hidden');
	}

	if (modalRecruitCancel)  modalRecruitCancel.addEventListener('click', function () { modalRecruit.classList.add('hidden'); });
	if (modalRecruitConfirm) modalRecruitConfirm.addEventListener('click', function () {
		var identifier = recruitPlayerSelect.value;
		var grade = recruitGradeSelect.value;
		if (!identifier || !grade) return;
		post('recruit', { identifier: identifier, grade: parseInt(grade, 10) });
		modalRecruit.classList.add('hidden');
	});

	// ===== Send salary =====
	function renderSalaryHistory() {
		if (!salaryHistoryList) return;
		var list = state.salaryHistory || [];
		if (list.length === 0) {
			salaryHistoryList.innerHTML = '<p class="empty">Aucun envoi.</p>';
			return;
		}
		salaryHistoryList.innerHTML = list.map(function (r) {
			var toName = ((r.to_firstname || '') + ' ' + (r.to_lastname || '')).trim() || '—';
			var typ = r.reason === 'salary' ? 'Salaire' : 'Bonus';
			return '<div class="journal-item">' +
				'<span><span class="label">' + escapeHTML(typ) + ' → ' + escapeHTML(toName) + '</span><span class="date">' + formatDate(r.created_at) + '</span></span>' +
				'<span class="amount entree">+ ' + formatMoney(r.amount) + '</span></div>';
		}).join('');
	}

	if (btnSendSalary) btnSendSalary.addEventListener('click', function () {
		// Avant : on excluait grade_name === 'boss' → impossible de verser un
		// salaire au patron. Le serveur (sendEmployeeMoney) ne refuse pas le
		// boss côté backend, donc on autorise désormais TOUS les employés
		// (boss et multi-jobs inclus) à recevoir un paiement depuis le menu.
		var employees = (state.employees || []);
		sendSalaryEmployeeSelect.innerHTML = '<option value="">-- Choisir --</option>' +
			employees.map(function (e) {
				var name = ((e.firstname || '') + ' ' + (e.lastname || '')).trim() || '—';
				var tag = '';
				if (e.job && e.job.grade_name === 'boss') tag = ' [Patron]';
				else if (e.is_multi) tag = ' [multi-job]';
				return '<option value="' + escapeHTML(e.identifier || '') + '">' + escapeHTML(name + tag) + '</option>';
			}).join('');
		sendSalaryAmountInput.value = '';
		modalSendSalary.classList.remove('hidden');
	});
	if (modalSendSalaryCancel)  modalSendSalaryCancel.addEventListener('click', function () { modalSendSalary.classList.add('hidden'); });
	if (modalSendSalaryConfirm) modalSendSalaryConfirm.addEventListener('click', function () {
		var identifier = sendSalaryEmployeeSelect.value;
		var amount = parseInt(sendSalaryAmountInput.value, 10);
		if (!identifier || !amount || amount <= 0) return;
		if (amount > MAX_SEND_SALARY) {
			showInlineError(sendSalaryAmountInput, 'Montant maximum : ' + MAX_SEND_SALARY.toLocaleString('fr-FR') + ' $.');
			return;
		}
		post('sendSalary', { identifier: identifier, amount: amount });
		modalSendSalary.classList.add('hidden');
	});

	// ===== Invoices =====
	function renderInvoices() {
		if (!invoicesList) return;
		var list = state.invoices || [];
		if (list.length === 0) {
			invoicesList.innerHTML = '<p class="empty">Aucune facture.</p>';
			return;
		}
		// Une ligne = une facture payée (kind 'bill') ou une vente encaissée
		// (kind 'sale'), avec l'employé et le client quand ils sont connus.
		invoicesList.innerHTML = list.map(function (inv) {
			var isBill = inv.kind === 'bill';
			var who = [];
			if (inv.employee_name) who.push(escapeHTML(inv.employee_name));
			if (inv.client_name)   who.push('→ ' + escapeHTML(inv.client_name));
			var title = (isBill ? '🧾 ' : '🛒 ') + escapeHTML(inv.label || (isBill ? 'Facture' : 'Vente'));
			var sub = who.length ? (' · ' + who.join(' ')) : '';
			return '<div class="journal-item">' +
				'<span><span class="label">' + title + sub + '</span><span class="date">' + formatDate(inv.created_at) + '</span></span>' +
				'<span class="amount entree">+ ' + formatMoney(inv.amount) + '</span></div>';
		}).join('');
	}
	if (btnRefreshInvoices) btnRefreshInvoices.addEventListener('click', function () { post('getInvoices'); });

	// ===== Service =====
	function renderServiceCurrent() {
		if (!serviceCurrentList) return;
		var list = state.serviceCurrent || [];
		if (list.length === 0) {
			serviceCurrentList.innerHTML = '<p class="empty">Personne en service.</p>';
			renderCounts();
			return;
		}
		serviceCurrentList.innerHTML = list.map(function (s) {
			var name = ((s.firstname || '') + ' ' + (s.lastname || '')).trim() || '—';
			var dur = formatDuration(s.duration_seconds);
			return '<div class="journal-item">' +
				'<span class="label">' + escapeHTML(name) + '</span>' +
				'<span class="amount entree">' + escapeHTML(dur) + '</span></div>';
		}).join('');
		renderCounts();
	}

	function renderServiceSessions() {
		if (!serviceSessionsBody) return;
		var list = state.serviceSessions || [];
		if (list.length === 0) {
			serviceSessionsBody.innerHTML = '<tr><td colspan="4" class="empty">Aucune session.</td></tr>';
			return;
		}
		serviceSessionsBody.innerHTML = list.map(function (s) {
			var name  = ((s.firstname || '') + ' ' + (s.lastname || '')).trim() || '—';
			var start = formatDate(s.started_at) + ' ' + formatTime(s.started_at);
			var end   = s.ended_at ? formatDate(s.ended_at) + ' ' + formatTime(s.ended_at) : '—';
			var dur   = formatDuration(s.duration_seconds);
			return '<tr>' +
				'<td class="member-name">' + escapeHTML(name) + '</td>' +
				'<td>' + start + '</td>' +
				'<td>' + end + '</td>' +
				'<td class="ta-right">' + dur + '</td>' +
			'</tr>';
		}).join('');
	}

	document.querySelectorAll('.filter-tab').forEach(function (btn) {
		btn.addEventListener('click', function () {
			var filter = this.getAttribute('data-filter');
			document.querySelectorAll('.filter-tab').forEach(function (b) { b.classList.remove('active'); });
			this.classList.add('active');
			state.serviceFilter = filter;
			post('getServiceSessions', { filter: filter });
		});
	});
	if (btnRefreshService) btnRefreshService.addEventListener('click', function () {
		post('getServiceCurrent');
		post('getServiceSessions', { filter: state.serviceFilter || 'day' });
		post('getMyServiceState');
	});

	// ===== Wash money =====
	function updateWashVisibility() {
		var navBlanchiment    = document.getElementById('navBlanchiment');
		var washNotAllowedMsg = document.getElementById('washNotAllowedMsg');
		var washPanel         = document.getElementById('washPanel');
		if (navBlanchiment)    navBlanchiment.style.display = state.washMoneyAllowed ? '' : 'none';
		if (washNotAllowedMsg) washNotAllowedMsg.style.display = state.washMoneyAllowed ? 'none' : '';
		if (washPanel)         washPanel.classList.toggle('hidden', !state.washMoneyAllowed);
	}
	var washAmountInput = document.getElementById('washAmountInput');
	var btnWashMoney    = document.getElementById('btnWashMoney');
	var WASH_MAX_AMOUNT = 50000000;
	if (btnWashMoney && washAmountInput) btnWashMoney.addEventListener('click', function () {
		var amount = parseInt(washAmountInput.value, 10);
		if (!amount || amount <= 0) return;
		if (amount > WASH_MAX_AMOUNT) {
			showInlineError(washAmountInput, 'Montant maximum par blanchiment : ' + WASH_MAX_AMOUNT.toLocaleString('fr-FR') + ' $.');
			return;
		}
		post('washMoney', { amount: amount });
		washAmountInput.value = '';
	});

	// ===== Permissions =====
	function getAllPermissionKeys(grades) {
		var keys = {};
		(grades || []).forEach(function (g) {
			if (g.permissions && typeof g.permissions === 'object') {
				Object.keys(g.permissions).forEach(function (k) { keys[k] = true; });
			}
		});
		return Object.keys(keys).sort();
	}

	function renderPermissions() {
		if (!permissionsThead || !permissionsBody) return;
		var grades = state.permissions || [];
		var permKeys = getAllPermissionKeys(grades);
		if (grades.length === 0) {
			permissionsBody.innerHTML = '<tr><td colspan="10" class="empty">Chargement…</td></tr>';
			return;
		}
		var labels = state.permissionLabels || {};
		permissionsThead.innerHTML = '<tr><th>Grade</th>' + permKeys.map(function (k) {
			return '<th>' + escapeHTML(labels[k] || k) + '</th>';
		}).join('') + '</tr>';
		permissionsBody.innerHTML = grades.map(function (g) {
			var cells = '<td class="member-name">' + escapeHTML(g.label || g.grade_name || g.grade) +
				' <span class="grade-num">(' + escapeHTML(g.grade) + ')</span></td>';
			permKeys.forEach(function (key) {
				var checked = g.permissions && g.permissions[key] ? ' checked' : '';
				cells += '<td class="perm-cell"><input type="checkbox" data-grade="' + escapeHTML(g.grade) + '" data-key="' + escapeHTML(key) + '"' + checked + ' /></td>';
			});
			return '<tr>' + cells + '</tr>';
		}).join('');
		permissionsBody.querySelectorAll('input[type="checkbox"]').forEach(function (cb) {
			cb.addEventListener('change', function () {
				var grade = parseInt(cb.getAttribute('data-grade'), 10);
				var key   = cb.getAttribute('data-key');
				var g = grades.find(function (r) { return Number(r.grade) === grade; });
				if (g) {
					if (!g.permissions) g.permissions = {};
					g.permissions[key] = cb.checked;
				}
			});
		});
	}

	if (btnSavePermissions) btnSavePermissions.addEventListener('click', function () {
		var society = state.society;
		if (!society || !state.permissions.length) return;
		state.permissions.forEach(function (g) {
			post('updatePerms', {
				job_name: society,
				grade: g.grade,
				permissions: g.permissions || {}
			});
		});
	});

	// ===== Webhook =====
	if (btnSaveWebhook && webhookInput) btnSaveWebhook.addEventListener('click', function () {
		var url = (webhookInput.value || '').trim();
		post('setSocietyWebhook', { url: url });
	});

	// ===== Modal close-X (sur toutes les croix .modal-x[data-close]) =====
	document.querySelectorAll('.modal-x[data-close]').forEach(function (x) {
		x.addEventListener('click', function () {
			var id = this.getAttribute('data-close');
			var m = document.getElementById(id);
			if (m) m.classList.add('hidden');
		});
	});
	// Cliquer sur le backdrop ferme aussi la modal
	document.querySelectorAll('.modal .modal-backdrop').forEach(function (bd) {
		bd.addEventListener('click', function () {
			var modal = this.closest('.modal');
			if (modal) modal.classList.add('hidden');
		});
	});

	// ===== NUI message =====
	window.addEventListener('message', function (event) {
		var data = event.data || {};
		if (data.action === 'open') {
			openUI();
			state.society         = data.society;
			state.balance         = data.balance || 0;
			state.transactions    = data.transactions || [];
			state.graphData       = data.graphData || [];
			state.employees       = data.employees || [];
			state.jobGrades       = (data.job && data.job.grades) ? data.job.grades : [];
			state.salaryHistory   = data.salaryHistory || [];
			state.invoices        = data.invoices || [];
			state.serviceCurrent  = data.serviceCurrent || [];
			state.serviceSessions = data.serviceSessions || [];
			state.serviceFilter   = data.serviceFilter || 'day';
			state.playerInService = data.playerInService === true;
			state.washMoneyAllowed= data.washMoneyAllowed === true;
			state.permissionLabels= data.permissionLabels || {};
			state.societyWebhook  = data.societyWebhook || '';
			state.currentIdentifier = data.currentIdentifier || '';

			updateWashVisibility();
			renderBalance();
			renderKpis();
			renderJournal();
			buildChart();
			renderMembers();
			renderSalaryHistory();
			renderInvoices();
			renderServiceCurrent();
			renderServiceSessions();
			renderFooterSociety();
			renderCounts();
			setHeader('compte');
			return;
		}
		if (data.action === 'update') {
			if (data.balance !== undefined) state.balance = data.balance;
			if (data.transactions) state.transactions = data.transactions;
			if (data.graphData)    state.graphData    = data.graphData;
			if (data.employees)    state.employees    = data.employees;
			renderBalance();
			renderKpis();
			renderJournal();
			buildChart();
			renderMembers();
			renderCounts();
			return;
		}
		if (data.action === 'setUnemployed') {
			state.unemployed = data.list || [];
			openRecruitModal();
			return;
		}
		if (data.action === 'close') { closeUI(); return; }
		if (data.action === 'updateSalaryHistory')  { state.salaryHistory  = data.list || []; renderSalaryHistory(); return; }
		if (data.action === 'updateInvoices')       { state.invoices       = data.list || []; renderInvoices();      return; }
		if (data.action === 'updateServiceCurrent') { state.serviceCurrent = data.list || []; renderServiceCurrent();return; }
		if (data.action === 'updateMyServiceState') { state.playerInService= data.inService === true;                return; }
		if (data.action === 'webhookSaved')         { state.societyWebhook = data.societyWebhook || '';              return; }
		if (data.action === 'updatePermissions')    { state.permissions    = data.list || []; renderPermissions();   return; }
		if (data.action === 'updateServiceSessions'){
			state.serviceSessions = data.list || [];
			if (data.filter) state.serviceFilter = data.filter;
			renderServiceSessions();
			return;
		}
	});

	// ===== Keyboard =====
	document.addEventListener('keydown', function (e) {
		if (e.key !== 'Escape') return;
		if (modalConfirm     && !modalConfirm.classList.contains('hidden'))     { closeConfirmModal(); return; }
		if (modalAmount      && !modalAmount.classList.contains('hidden'))      { closeAmountModal(); return; }
		if (modalRecruit     && !modalRecruit.classList.contains('hidden'))     { modalRecruit.classList.add('hidden'); return; }
		if (modalGrade       && !modalGrade.classList.contains('hidden'))       { modalGrade.classList.add('hidden'); return; }
		if (modalSendSalary  && !modalSendSalary.classList.contains('hidden'))  { modalSendSalary.classList.add('hidden'); return; }
		closeUI();
		post('close');
	});
})();

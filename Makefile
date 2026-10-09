PY ?= python3
RUN ?= outputs/smoke

.PHONY: install test lint toy smoke app clean
install:
	$(PY) -m pip install -e ".[dev,app]"
test:
	$(PY) -m pytest
lint:
	ruff check src scripts tests app
toy:
	$(PY) scripts/make_toy_dataset.py --out data/toy
# End-to-end plumbing check on SYNTHETIC TOY data (not a scientific result).
smoke: toy
	$(PY) scripts/build_manifest.py --config configs/smoke.yaml --hash
	$(PY) scripts/validate_dataset.py --config configs/smoke.yaml
	$(PY) scripts/prepare_splits.py --config configs/smoke.yaml
	$(PY) scripts/train.py --config configs/smoke.yaml
	$(PY) scripts/evaluate.py --run-dir $(RUN)
	$(PY) scripts/analyze_drift.py --run-dir $(RUN)
	$(PY) scripts/generate_explanations.py --run-dir $(RUN)
	$(PY) scripts/report_matrix.py
app:
	streamlit run app/app.py
clean:
	rm -rf outputs data/toy

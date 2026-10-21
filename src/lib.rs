pub mod app;
pub mod core;

pub use app::{run, App};
pub use core::State;

#[cfg(target_arch = "wasm32")]
use wasm_bindgen::prelude::*;

#[cfg(target_arch = "wasm32")]
#[wasm_bindgen(start)]
pub fn run_web() -> Result<(), wasm_bindgen::JsValue> {
    console_error_panic_hook::set_once();
    run().map_err(|e| wasm_bindgen::JsValue::from_str(&e.to_string()))?;

    Ok(())
}

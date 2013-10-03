class CheckWithSelectAllInput < Formtastic::Inputs::CheckBoxesInput
	def to_html

		%{
			<li class="check_boxes input optional" id="user_type_select_all_input">
				<fieldset class="choices">
					<legend class="label">
						<label></label>
					</legend>
					<ol class="choices-group">
						<li class="choice">
							<label for="#{method}_select_all_true">
								<input id="#{method}_select_all" onclick="act_on_all_checks_#{method}(this)" type="checkbox" value="true">Selecionar todos
							</label>
						</li>
					</ol>
				</fieldset>
			</li>

			<script type="text/javascript">
					var name_check_#{method}_ids = null;
					var checks_#{method} = null;
					var last_all_check_box_clicked_#{method} = null;
					

				$(document).ready(function(){
					name_check_#{method}_ids = "#{object_name}[#{method}_ids][]";
					prepare_checks_#{method}();
					last_all_check_box_clicked_#{method} = $('##{method}_select_all');

					if(#{!object.new_record?}){
						check_all_ckecks_#{method}();
					}
				})
				
				function prepare_checks_#{method}(){
					checks_#{method} = $('.choices-group input[name="'+name_check_#{method}_ids+'"]')
				}

				function check_all_ckecks_#{method}(){
					var all_checked = true;

					checks_#{method}.each(
						function(i, e){
							if (!$(e).prop('checked')){
								all_checked = false;
								return false;
							}
						}
					);

					if (checks_#{method}.size() == 0){
						all_checked = false;
					}

					if (all_checked){
						select_all_#{method}();
					}
				}

				function set_last_all_check_box_clicked_#{method}( p_check ) {
					last_all_check_box_clicked_#{method} = $(p_check);
					var name_check_#{method}_ids = "#{object_name}[#{method}_ids][]";
				}

				function act_on_all_checks_#{method}( checkbox_element ){

					set_last_all_check_box_clicked_#{method}( $(checkbox_element) );

					if (last_all_check_box_clicked_#{method}.prop('checked')){
						select_all_#{method}();
					} else {
						deselect_all_#{method}();
					}
				}

				function act_on_one_check_#{method}(checkbox_element){

					if(!$(checkbox_element).prop('checked')){
						deselect_select_all_check_#{method}();
					} else {
						var all_checked = true;

						checks_#{method}.each(function(i, e){
							if(!$(e).prop('checked')){
								all_checked = false
							}
						});	

						if(all_checked){
							check_all_ckecks_#{method}();
						}
					}
				}

				function select_all_#{method}(){
					prepare_checks_#{method}();

					checks_#{method}.each(function(i, e){
						$(e).prop('checked', true)
					});	

					last_all_check_box_clicked_#{method}.prop('checked', true);
				}

				function deselect_all_#{method}(){
					prepare_checks_#{method}();
					
					checks_#{method}.each(function(i, e){ $(e).prop('checked', false)})	
					last_all_check_box_clicked_#{method}.prop('checked', false);
				}

				function deselect_select_all_check_#{method}(){
					last_all_check_box_clicked_#{method}.prop('checked', false);	
				}

			</script>
		}.html_safe
	end
end